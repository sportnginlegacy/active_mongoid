require "active_mongoid/associations/mongoid/macros"
require "active_mongoid/associations/mongoid/accessors"
require "active_mongoid/associations/mongoid/builders"
require "active_mongoid/associations/mongoid/auto_save"
require "active_mongoid/associations/mongoid/dependent"
require "active_mongoid/associations/mongoid/bindings/one"
require "active_mongoid/associations/mongoid/bindings/in"
require "active_mongoid/associations/mongoid/bindings/many"
require "active_mongoid/associations/mongoid/referenced/one"
require "active_mongoid/associations/mongoid/referenced/in"
require "active_mongoid/associations/mongoid/referenced/many"

module ActiveMongoid
  module Associations
    module Mongoid
      module Associations
        extend ActiveSupport::Concern

        attr_accessor :__metadata__

        included do
          include Mongoid::Macros
          include Mongoid::Accessors
          include Mongoid::Builders
          include Mongoid::AutoSave
          include Mongoid::Dependent
        end

        def referenced_many_records?
          __metadata__ && __metadata__.macro == :has_many_records
        end

        def referenced_one_record?
          __metadata__ && __metadata__.macro == :has_one_record
        end


        def reload_relations
          am_relations.each_pair do |name, meta|
            if instance_variable_defined?("@#{name}")
              if instance_variable_get("@#{name}")
                remove_instance_variable("@#{name}")
              end
            end
          end
        end

      end
    end
  end
end

