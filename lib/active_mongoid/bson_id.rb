module ActiveMongoid
  module BsonId
    extend ActiveSupport::Concern

    included do
      class_attribute :bson_attrs
      class_attribute :primary_bson_key
      self.bson_attrs = []
    end

    module ClassMethods

      def bsonify_attr(name, options = {})
        bson_attr_setter(name)
        bson_attr_getter(name) unless options[:primary]
        bson_attrs << name
        bson_attr_init(name) if options[:initialize]
        set_ar_primary_bson_id(name) if options[:primary]
      end

      def set_ar_primary_bson_id(name)
        self.primary_key = name
        self.primary_bson_key = name
        alias_attribute "_#{name}".to_sym, name
      end

      private

      def bson_attr_setter(name)
        self.instance_eval do
          define_method("#{name}=") do |object|
            attribute = object.nil? ? nil : object.to_s
            write_attribute(name, attribute)
          end
        end
      end

      def bson_attr_getter(name)
        self.instance_eval do
          define_method(name) do
            attribute = read_attribute(name)
            attribute.nil? ? nil : ::ActiveMongoid::BSON::ObjectId.from_string(attribute)
          end
        end
      end

      def bson_attr_init(name)
        init_method = :"init_attr_for_#{name}"
        define_method(init_method) do
          self.send("#{name}=", ::ActiveMongoid::BSON::ObjectId.new) unless read_attribute(name)
        end
        after_initialize init_method
      end

    end

  end
end
