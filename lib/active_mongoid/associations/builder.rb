module ActiveMongoid
  module Associations
    class Builder

      attr_reader :base, :metadata, :object

      def initialize(base, metadata, object)
        @base = base
        @metadata = metadata
        @object = object
      end

      protected

      def klass
        @klass ||= metadata.klass
      end

      def query?
        obj = Array(object).first
        !obj.is_a?(::Mongoid::Document) && !obj.is_a?(::ActiveRecord::Base) && !obj.nil?
      end

    end
  end
end
