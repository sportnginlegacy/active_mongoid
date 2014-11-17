# ActiveMongoid
[![Build Status][build_status_image]][build_status]
[![Coverage Status][coverage_status_image]][coverage_status]

ActiveMongoid facilitates usage of both ActiveRecord and Mongoid in a single rails application by providing an inteface for inter-ORM relations. It was written to replace select Mongoid models with ActiveRecord versions, so it tries to adhere to the Mongoid API as closely as possible. To accomplish this compatibility, much of the logic and structure of this lib are either directly inspired or straight up ripped off the Mongoid source.

## Installation

Add this line to your application's Gemfile:

    gem 'active_mongoid'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_mongoid

## Usage by Example

### ActiveMongoid::Associations

#### ActiveRecord

```ruby
class Player < ActiveRecord::Base
  include ActiveMongoid::Associations

  belongs_to_document :team
  has_one_document :stat, as: :target, autosave: true, dependent: :destroy
end
```

#### Mongoid
```ruby
class Team
  include Mongoid::Document
  include ActiveMongoid::Associations

  has_many_records :players, autosave: true, order: "name asc"
  belongs_to_record :division
end
```

```ruby
> team = Team.create
=> #<Team _id: 5453d55cb736b692ab000001, name: nil>
> player = team.players.build(name: "foo") # create will call save
=> #<Player id: nil, name: "foo", team_id: "5453d55cb736b692ab000001">
> team.player << Player.new(name: "foo1")
=> #<Player id: nil, name: "foo1", team_id: "5453d55cb736b692ab000001">
> team.players
=> [#<Player id: nil, name: "foo", team_id: "5453d55cb736b692ab000001">, #<Player id: nil, name: "foo1", team_id: "5453d55cb736b692ab000001">] 
> player.team # binds the inverse
=> #<Team _id: 5453d55cb736b692ab000001, name: nil>
> team.save
=> true
> team.players
=> [#<Player id: 1, name: "foo", team_id: "5453d55cb736b692ab000001">, #<Player id: 2, name: "foo1", team_id: "5453d55cb736b692ab000001">] 
> team.players.where(name: "foo")
=> [#<Player id: 1, name: "foo", team_id: "5453d55cb736b692ab000001">] 
> player = Player.create(name: "baz")
=> #<Player id: 3, name: "baz", team_id: nil>
> team = player.build_team(name: "bar")  # create_ will call save
=> #<Team _id: 5453d55cb736b692ab000002, name: "bar">
> team.players
=> [#<Player id: 3, name: "foo", team_id: "5453d55cb736b692ab000002">] 
> player.team(true) # forces reload from database
=> nil 
```


## API Documentation

### ActiveMongoid::Associations

#### Record Relation Class Methods
* ```has_many_records :players``` 
* ```has_man_record :player``` 
* ```belongs_to_record :player``` 
  
#### Document Relation Class Methods
* ```has_many_documents :stats``` 
* ```has_one_record :stat``` 
* ```belongs_to_record :stat``` 

#### Options
All relations accept the following options:
  - ```order``` Needs to be formated according to ActiveRecord/Mongoid spec respectively
  - ```dependent``` Accepts: `:destroy, :delete`
  - ```as``` Polymorphic relation
  - ```foreign_key``` Foreign key for relation
  - ```primary_key``` Primary key for relation
  - ```class_name``` Relation class name
  - ```autosave``` Accepts `:true`

#### Record/Document Relation Has Many Instance Methods
* ```team.players``` Returns the relation
* ```team.players(true)``` Forces reload from database and returns relation
* ```team.players = [player]``` Assigns objects and calls dependent method on old values
* ```team.players << player``` Appends object and will save if base is persisted
* ```team.players.build({player.attributes})``` Builds and binds object from attributes and binds relation
* ```team.players.concat([player_1, player_2]``` Appends and binds array of objects. Will save if base is persisted
* ```team.players.purge``` Removes all objects from relation and calls dependent method on objects
* ```team.players.delete(player)``` Removes object and calls dependent method on object
* ```team.players.delete_all()``` Calls delete on all objects
* ```team.players.destroy_all()``` Calls destroy on all objects
* ```team.players.each``` Iterate on onjects
* ```team.players.exists?``` Calls exists? on relation
* ```team.players.find(params)``` Return relation with criteria added
* ```team.players.nullify``` Clears loaded relation 
* ```team.players.blank?``` Returns `true` if empty
* ```team.players.create({player.attributes})``` Creates and binds from attributes
* ```team.players.create!({player.attributes})``` Creates and binds form attributes and raises an exception if fails
* ```team.players.find_or_create_by({player.attributes})``` Finds or creates a record from attributes
* ```team.players.find_or_initialize_by({player.attributes})``` Finds or initializes a record from attributes
* ```team.players.nil?``` returns `false`

All other methods will defer to the ActiveRecord/Mongoid relation respectively.

#### Record/Document Relation Has One and Belongs To Instance Methods
* ```player.stat``` Returns the relation
* ```player.stat(true)``` Forces reload from database and returns relation
* ```player.stat = stat``` Assigns object as relation. Will substitute old value and call dependent method
* ```player.build_stat({})``` Builds and binds new object from attributes 
* ```player.create_stat({})``` Creates and binds new object from attributes

All other methods called on relation will defer to the object.

### ActiveMongoid::BsonId

```ruby
class Division < ActiveRecord::Base
  include ActiveMongoid::BsonId
  bsonify_attr :_id, initialize: true
end
```

```ruby
> division._id
=> BSON::ObjectId('545289a7b736b6586a000001')
> division._id = BSON::ObjectId('545289a7b736b6586a000002')
=> BSON::ObjectId('545289a7b736b6586a000002')
> division._id = '545289a7b736b6586a000002'
=> BSON::ObjectId('545289a7b736b6586a000002')
```

### ActiveMongoid::Finders

```ruby
class Division < ActiveRecord::Base
  include ActiveMongoid::BsonId
  include ActiveMongoid::Finders
  bsonify_attr :_id, initialize: true
end
```

```ruby
> Division.find(1)
=> #<Tournament id: 1, _id: "545289a7b736b6586a000001", name: "new tournament">
> Division.find(BSON::ObjectId('545289a7b736b6586a000001')
=> #<Tournament id: 1, _id: "545289a7b736b6586a000001", name: "new tournament">
> Division.where(_id: BSON::ObjectId('545289a7b736b6586a000001')
=> [#<Tournament id: 1, _id: "545289a7b736b6586a000001", name: "new tournament">]
> Division.where(id: BSON::ObjectId('545289a7b736b6586a000001')
=> [#<Tournament id: 1, _id: "545289a7b736b6586a000001", name: "new tournament">]
```



## Contributing

1. Fork it ( https://github.com/[my-github-username]/active_mongoid/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[build_status]: https://travis-ci.org/sportngin/active_mongoid
[build_status_image]: https://travis-ci.org/sportngin/active_mongoid.svg?branch=master
[coverage_status]: https://coveralls.io/r/sportngin/active_mongoid
[coverage_status_image]: https://img.shields.io/coveralls/sportngin/active_mongoid.svg
