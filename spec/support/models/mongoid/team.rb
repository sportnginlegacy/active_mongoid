class Team
  include Mongoid::Document
  include ActiveMongoid

  field :name

  has_many_records :players
  belongs_to_record :division
end
