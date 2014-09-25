require "active_mongoid/associations/record_relation/macros"
require "active_mongoid/associations/record_relation/accessors"
require "active_mongoid/associations/record_relation/builders"
require "active_mongoid/associations/record_relation/auto_save"
require "active_mongoid/associations/record_relation/dependent"
require "active_mongoid/associations/record_relation/finders"
require "active_mongoid/associations/record_relation/bson_id"
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
          include RecordRelation::Accessors
          include RecordRelation::Macros
          include RecordRelation::Builders
          include RecordRelation::AutoSave
          include RecordRelation::Dependent
        end

        def referenced_many_documents?
          __metadata__ && __metadata__.macro == :has_many_documents
        end

        def referenced_one_document?
          __metadata__ && __metadata__.macro == :has_one_document
        end

      end
    end
  end
end

