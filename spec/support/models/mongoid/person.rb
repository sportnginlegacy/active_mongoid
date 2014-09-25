class Person
  include Mongoid::Document
  include ActiveMongoid

  field :name

  belongs_to_record :player
end
