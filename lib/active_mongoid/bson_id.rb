module ActiveMongoid
  module BsonId
    extend ActiveSupport::Concern

    included do
      bsonify_attr :_id, initialize: true
      after_initialize :set_bson_id
    end

    module ClassMethods

      def bsonify_attr(name, options = {})
        bson_attr_setter(name)
        bson_attr_getter(name)
        bson_attr_init(name) if options[:initialize]
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
            attribute.nil? ? nil : BSON::ObjectId.from_string(attribute)
          end
        end
      end

      def bson_attr_init(name)
        init_method = :"init_attr_for_#{metadata.name}"
        define_method(init_method) do
          self.send("#{name}=") = BSON::ObjectId.new unless read_attribute(name)
        end
        after_initialize init_method
      end

    end

  end
end
