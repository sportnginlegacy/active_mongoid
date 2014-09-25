module ActiveMongoid
  module Associations
    module RecordRelation
      module BsonId
        extend ActiveSupport::Concern

        included do
          after_initialize :set_bson_id
        end

        def set_bson_id
          self._id = BSON::ObjectId.new unless read_attribute(:_id)
        end

        def _id=(bson_id)
          attribute = bson_id.nil? ? nil : bson_id.to_s
          write_attribute(:_id, attribute)
        end

        def _id
          attribute = read_attribute(:_id)
          attribute.nil? ? nil : BSON::ObjectId.from_string(attribute)
        end

      end
    end
  end
end
