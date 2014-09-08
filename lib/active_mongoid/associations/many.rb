module ActiveMongoid
  module Associations
    class Many < Proxy

      delegate :avg, :max, :min, :sum, to: :criteria
      delegate :length, :size, to: :target

      def blank?
        size == 0
      end

      def create(attributes = nil, type = nil, &block)
        if attributes.is_a?(::Array)
          attributes.map { |attrs| create(attrs, type, &block) }
        else
          obj = build(attributes, type, &block)
          base.persisted? ? obj.save : raise_unsaved(obj)
          obj
        end
      end

      def create!(attributes = nil, type = nil, &block)
        if attributes.is_a?(::Array)
          attributes.map { |attrs| create!(attrs, type, &block) }
        else
          obj = build(attributes, type, &block)
          base.persisted? ? obj.save! : raise_unsaved(obj)
          obj
        end
      end

      def find_or_create_by(attrs = {}, type = nil, &block)
        find_or(:create, attrs, type, &block)
      end

      def find_or_initialize_by(attrs = {}, type = nil, &block)
        find_or(:build, attrs, type, &block)
      end

      def nil?
        false
      end

      def respond_to?(name, include_private = false)
        [].respond_to?(name, include_private) ||
          klass.respond_to?(name, include_private) || super
      end

      def scoped
        criteria
      end

      def unscoped
        criteria.unscoped
      end

      def raise_unsaved(obj)
        # raise new exception
      end

      private

      def find_or(method, attrs = {}, type = nil, &block)
        attrs["_type"] = type.to_s if type
        where(attrs).first || send(method, attrs, type, &block)
      end


    end
  end
end
