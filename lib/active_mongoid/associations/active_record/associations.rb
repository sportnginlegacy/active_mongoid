require "active_mongoid/associations/active_record/macros"
require "active_mongoid/associations/active_record/accessors"
require "active_mongoid/associations/active_record/builders"
require "active_mongoid/associations/active_record/auto_save"
require "active_mongoid/associations/active_record/bindings/one"
require "active_mongoid/associations/active_record/bindings/in"
require "active_mongoid/associations/active_record/bindings/many"
require "active_mongoid/associations/active_record/referenced/one"
require "active_mongoid/associations/active_record/referenced/in"
require "active_mongoid/associations/active_record/referenced/many"

module ActiveMongoid
  module Associations
    module ActiveRecord
      module Associations
        extend ActiveSupport::Concern

        included do
          include ActiveRecord::Accessors
          include ActiveRecord::Macros
          include ActiveRecord::Builders
          include ActiveRecord::AutoSave
        end

      end
    end
  end
end

