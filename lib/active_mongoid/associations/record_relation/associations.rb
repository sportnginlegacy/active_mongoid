require "active_mongoid/associations/record_relation/macros"
require "active_mongoid/associations/record_relation/accessors"
require "active_mongoid/associations/record_relation/builders"
require "active_mongoid/associations/record_relation/auto_save"
require "active_mongoid/associations/record_relation/dependent"
require "active_mongoid/associations/record_relation/bindings/one"
require "active_mongoid/associations/record_relation/bindings/in"
require "active_mongoid/associations/record_relation/bindings/many"
require "active_mongoid/associations/record_relation/referenced/one"
require "active_mongoid/associations/record_relation/referenced/in"
require "active_mongoid/associations/record_relation/referenced/many"

module ActiveMongoid
  module Associations
    module RecordRelation
      module Associations
        extend ActiveSupport::Concern

        attr_accessor :__metadata__

        included do
          include RecordRelation::Macros
          include RecordRelation::Accessors
          include RecordRelation::Builders
          include RecordRelation::AutoSave
          include RecordRelation::Dependent
        end

        def referenced_many_records?
          __metadata__ && __metadata__.macro == :has_many_records
        end

        def referenced_one_record?
          __metadata__ && __metadata__.macro == :has_one_record
        end

      end
    end
  end
end

