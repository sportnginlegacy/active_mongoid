require "active_mongoid/associations/metadata"
require "active_mongoid/associations/builder"
require "active_mongoid/associations/binding"
require "active_mongoid/associations/proxy"
require "active_mongoid/associations/one"
require "active_mongoid/associations/many"
require "active_mongoid/associations/builders/in"
require "active_mongoid/associations/builders/one"
require "active_mongoid/associations/builders/many"
require "active_mongoid/associations/record_relation/associations"
require "active_mongoid/associations/document_relation/associations"
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
        include RecordRelation::Associations
      elsif defined?(::Mongoid::Document) && self.included_modules.include?(::Mongoid::Document)
        include DocumentRelation::Associations
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

    module ClassMethods

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
