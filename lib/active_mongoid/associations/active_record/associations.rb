require "active_mongoid/associations/active_record/macros"
require "active_mongoid/associations/active_record/accessors"

module ActiveMongoid
  module Associations
    module ActiveRecord
      module Associations
        extend ActiveSupport::Concern

        included do
          include ActiveRecord::Accessors
          include ActiveRecord::Macros
        end

      end
    end
  end
end

