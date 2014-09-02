require "active_mongoid/associations/mongoid/macros"
require "active_mongoid/associations/mongoid/accessors"

module ActiveMongoid
  module Associations
    module Mongoid
      module Associations
        extend ActiveSupport::Concern

        included do
          include Mongoid::Macros
          include Mongoid::Accessors
        end

      end
    end
  end
end

