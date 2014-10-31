class Division < ActiveRecord::Base
  include ActiveMongoid::Associations
  include ActiveMongoid::Finders
  include ActiveMongoid::BsonId

  has_many_documents :teams, order: [:name, :asc]
  belongs_to_document :league
  belongs_to_document :post, foreign_key: :pid
  has_many_documents :stats, as: :target

  scope :sport_id, ->(id){ where(sport_id: id) }
  scope :by_name, ->(n){ where(name: n) }

  bsonify_attr :_id, initialize: true
  bsonify_attr :sport_id
end
