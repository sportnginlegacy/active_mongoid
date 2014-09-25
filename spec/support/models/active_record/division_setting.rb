module Settings
  class DivisionSetting < ActiveRecord::Base
    include ActiveMongoid::Associations
    include ActiveMongoid::Associations::DocumentRelation::Finders

    belongs_to_document :league
  end
end

