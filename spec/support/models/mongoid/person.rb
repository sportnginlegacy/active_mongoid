class Person
  include Mongoid::Document
  include ActiveMongoid::Associations

  belongs_to_record :player
end
