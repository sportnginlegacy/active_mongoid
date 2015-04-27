require "active_mongoid/associations/document_relation/macros"
require "active_mongoid/associations/document_relation/accessors"
require "active_mongoid/associations/document_relation/builders"
require "active_mongoid/associations/document_relation/auto_save"
require "active_mongoid/associations/document_relation/dependent"
require "active_mongoid/associations/document_relation/bindings/one"
require "active_mongoid/associations/document_relation/bindings/in"
require "active_mongoid/associations/document_relation/bindings/many"
require "active_mongoid/associations/document_relation/referenced/one"
require "active_mongoid/associations/document_relation/referenced/in"
require "active_mongoid/associations/document_relation/referenced/many"
require "active_mongoid/associations/document_relation/referenced/many_to_many"


module ActiveMongoid
  module Associations
    module DocumentRelation
      module Associations
        extend ActiveSupport::Concern

        attr_accessor :__metadata__

        included do
          include DocumentRelation::Accessors
          include DocumentRelation::Macros
          include DocumentRelation::Builders
          include DocumentRelation::AutoSave
          include DocumentRelation::Dependent
        end

      end
    end
  end
end

