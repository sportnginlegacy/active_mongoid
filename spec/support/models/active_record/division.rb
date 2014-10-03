class Division < ActiveRecord::Base
  include ActiveMongoid::Associations
  include ActiveMongoid::Finders
  include ActiveMongoid::BsonId

  has_many_documents :teams
  belongs_to_document :league
  belongs_to_document :post, foreign_key: :pid

  bsonify_attr :_id, initialize: true
  bsonify_attr :sport_id
end
