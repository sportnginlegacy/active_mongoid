require "active_mongoid/associations/metadata"
require "active_mongoid/associations/builder"
require "active_mongoid/associations/binding"
require "active_mongoid/associations/proxy"
require "active_mongoid/associations/one"
require "active_mongoid/associations/many"
require "active_mongoid/associations/builders/in"
require "active_mongoid/associations/builders/one"
require "active_mongoid/associations/builders/many"
require "active_mongoid/associations/active_record/associations"
require "active_mongoid/associations/mongoid/associations"

module ActiveMongoid
  module Associations
    extend ActiveSupport::Concern

    included do
      class_attribute :am_relations
      self.am_relations = {}

      if defined?(::ActiveRecord::Base) && self <= ::ActiveRecord::Base
        include ActiveRecord::Associations
      elsif defined?(::Mongoid::Document) && self.included_modules.include?(::Mongoid::Document)
        include Mongoid::Associations
      else
        raise
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
