module ActiveMongoid
  module Associations
    class Builder

      attr_reader :base, :__metadata__, :object

      def initialize(base, metadata, object)
        @base = base
        @__metadata__ = metadata
        @object = object
      end

      protected

      def klass
        @klass ||= __metadata__.klass
      end

      def query?
        obj = Array(object).first
        !obj.is_a?(::Mongoid::Document) && !obj.is_a?(::ActiveRecord::Base) && !obj.nil?
      end

    end
  end
end
