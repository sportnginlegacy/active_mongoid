class Address < ActiveRecord::Base
  include ActiveMongoid::Associations
  include ActiveMongoid::Finders

  belongs_to_document :target, polymorphic: true
end
