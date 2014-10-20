require "active_mongoid/associations/metadata"
require "active_mongoid/associations/builder"
require "active_mongoid/associations/binding"
require "active_mongoid/associations/proxy"
require "active_mongoid/associations/one"
require "active_mongoid/associations/many"
require "active_mongoid/associations/builders/in"
require "active_mongoid/associations/builders/one"
require "active_mongoid/associations/builders/many"
require "active_mongoid/associations/document_relation/associations"
require "active_mongoid/associations/record_relation/associations"
require "active_mongoid/associations/targets/enumerable"
require 'after_do'

module ActiveMongoid
  module Associations
    extend ActiveSupport::Concern

    included do
      extend ::AfterDo
      class_attribute :am_relations
      self.am_relations = {}

      if defined?(::ActiveRecord::Base) && self <= ::ActiveRecord::Base
        include DocumentRelation::Associations
      elsif defined?(::Mongoid::Document) && self.included_modules.include?(::Mongoid::Document)
        include RecordRelation::Associations
      else
        raise
      end

      before :reload do
        am_relations.each_pair do |name, meta|
          if instance_variable_defined?("@#{name}")
            if instance_variable_get("@#{name}")
              remove_instance_variable("@#{name}")
            end
          end
        end
      end
    end

    def reflect_on_am_association(name)
      self.class.reflect_on_am_association(name.to_s)
    end

    def referenced_many_records?
      __metadata__ && __metadata__.macro == :has_many_records
    end

    def referenced_one_record?
      __metadata__ && __metadata__.macro == :has_one_record
    end

    def referenced_many_documents?
      __metadata__ && __metadata__.macro == :has_many_documents
    end

    def referenced_one_document?
      __metadata__ && __metadata__.macro == :has_one_document
    end

    module ClassMethods

      def reflect_on_am_association(name)
        am_relations[name.to_s]
      end

      private

      def characterize_association(name, relation, options)
        ActiveMongoid::Associations::Metadata.new({
          :relation => relation,
          :inverse_class_name => self.name,
          :name => name
        }.merge(options))
      end

    end

  end
end
