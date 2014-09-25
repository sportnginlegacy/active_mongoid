require "active_mongoid/associations"

module ActiveMongoid
  extend ActiveSupport::Concern

  included do
    include ActiveMongoid::Associations
  end
end
