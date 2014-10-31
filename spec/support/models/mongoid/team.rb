class Team
  include Mongoid::Document
  include ActiveMongoid::Associations

  field :name

  has_many_records :players, order: 'name asc'
  belongs_to_record :division
end
