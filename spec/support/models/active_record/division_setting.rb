module Settings
  class DivisionSetting < ActiveRecord::Base
    include ActiveMongoid::Associations
    include ActiveMongoid::Finders

    belongs_to_document :league
  end
end

