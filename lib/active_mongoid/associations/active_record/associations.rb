require "active_mongoid/associations/active_record/macros"
require "active_mongoid/associations/active_record/accessors"
require "active_mongoid/associations/active_record/builders"
require "active_mongoid/associations/active_record/auto_save"
require "active_mongoid/associations/active_record/dependent"
require "active_mongoid/associations/active_record/finders"
require "active_mongoid/associations/active_record/bson_id"
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

        attr_accessor :__metadata__

        included do
          include ActiveRecord::Accessors
          include ActiveRecord::Macros
          include ActiveRecord::Builders
          include ActiveRecord::AutoSave
          include ActiveRecord::Dependent
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

