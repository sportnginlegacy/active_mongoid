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

## Usage

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
