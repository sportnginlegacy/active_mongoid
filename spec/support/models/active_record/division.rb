class Division < ActiveRecord::Base
  include ActiveMongoid::Associations
  include ActiveMongoid::Associations::DocumentRelation::Finders

  has_many_documents :teams
  belongs_to_document :league
  belongs_to_document :post, foreign_key: :pid
end
