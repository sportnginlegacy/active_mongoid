class Play < ActiveRecord::Base
  include ActiveMongoid::Associations
  include ActiveMongoid::Finders
  include ActiveMongoid::BsonId

  scope :by_name, ->(n){ where(name: n) }
  scope :sport_id, ->(id){ where(sport_id: id) }

  bsonify_attr :id, initialize: true, primary: true
  bsonify_attr :sport_id
end
