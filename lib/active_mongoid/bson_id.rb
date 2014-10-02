module ActiveMongoid
  module BsonId
    extend ActiveSupport::Concern

    included do
      bsonify_attr :_id
      after_initialize :set_bson_id
    end

    def set_bson_id
      self._id = BSON::ObjectId.new unless read_attribute(:_id)
    end

    module ClassMethods

      def bsonify_attr(name)
        bson_attr_setter(name)
        bson_attr_getter(name)
      end

      private

      def bson_attr_setter(name)
        self.instance_eval do
          define_method("#{name}=") do |object|
            attribute = object.nil? ? nil : object.to_s
            write_attribute(:_id, attribute)
          end
        end
      end

      def bsob_attr_getter(name)
        self.instance_eval do
          define_method(name) do
            attribute = read_attribute(name)
            attribute.nil? ? nil : BSON::ObjectId.from_string(attribute)
          end
        end
      end

    end

  end
end
