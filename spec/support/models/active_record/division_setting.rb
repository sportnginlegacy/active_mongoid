module Settings
  class DivisionSetting < ActiveRecord::Base
    include ActiveMongoid::Associations
    include ActiveMongoid::Associations::ActiveRecord::Finders

    belongs_to_document :league
  end
end

