require "active_mongoid/associations/mongoid/macros"
require "active_mongoid/associations/mongoid/accessors"
require "active_mongoid/associations/mongoid/builders"
require "active_mongoid/associations/mongoid/auto_save"
require "active_mongoid/associations/mongoid/bindings/one"
require "active_mongoid/associations/mongoid/bindings/in"
require "active_mongoid/associations/mongoid/referenced/one"
require "active_mongoid/associations/mongoid/referenced/in"

module ActiveMongoid
  module Associations
    module Mongoid
      module Associations
        extend ActiveSupport::Concern

        included do
          include Mongoid::Macros
          include Mongoid::Accessors
          include Mongoid::Builders
          include Mongoid::AutoSave
        end

      end
    end
  end
end

