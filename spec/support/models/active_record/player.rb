class Player < ActiveRecord::Base
  include ActiveMongoid::Associations
  include ActiveMongoid::Finders

  belongs_to_document :team
  has_one_document :person
  has_one_document :post
end
