module Settings
  class DivisionSetting < ActiveRecord::Base
    include ActiveMongoid::Associations

    belongs_to_document :league
  end
end

