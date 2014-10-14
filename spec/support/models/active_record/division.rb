class Division < ActiveRecord::Base
  include ActiveMongoid::Associations
  include ActiveMongoid::Finders
  include ActiveMongoid::BsonId

  has_many_documents :teams
  belongs_to_document :league
  belongs_to_document :post, foreign_key: :pid
  has_one_document :stat, as: :target, polymorphic: true

  scope :sport_id, ->(id){ where(sport_id: id) }
  scope :by_name, ->(n){ where(name: n) }

  bsonify_attr :_id, initialize: true
  bsonify_attr :sport_id
end
