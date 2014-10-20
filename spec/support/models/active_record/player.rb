class Player < ActiveRecord::Base
  include ActiveMongoid::Associations
  include ActiveMongoid::Finders
  include ActiveMongoid::BsonId

  bsonify_attr :_id, initialize: true

  belongs_to_document :team
  has_one_document :person
  has_one_document :post
  has_one_document :stat, as: :target
end
