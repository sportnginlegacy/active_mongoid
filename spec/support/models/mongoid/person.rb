class Person
  include Mongoid::Document
  include ActiveMongoid::Associations

  field :name

  belongs_to_record :player
  has_many_records :addresses, as: :target
end
