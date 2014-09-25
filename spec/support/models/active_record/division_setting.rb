module Settings
  class DivisionSetting < ActiveRecord::Base
    include ActiveMongoid
    include ActiveMongoid::Associations::RecordRelation::Finders

    belongs_to_document :league
  end
end

