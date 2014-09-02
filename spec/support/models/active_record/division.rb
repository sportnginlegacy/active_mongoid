class Division < ActiveRecord::Base
  include ActiveMongoid::Associations

  # has_many_documents :teams
  # belongs_to_document :league
end
