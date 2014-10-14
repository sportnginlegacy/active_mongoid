class Stat
  include Mongoid::Document
  include ActiveMongoid::Associations

  field :value

  belongs_to_record :target, polymorphic: true
end
