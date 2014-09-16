module ActiveMongoid
  module Associations
    module ActiveRecord
      module Finders
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

        module ClassMethods

          def find(*args)
            key = args.flatten.first
            if key.is_a?(String) || key.is_a?(BSON::ObjectId)
              where({_id: key})
            else
              super(*args)
            end
          end

          def where(opts = :chain, *rest)
            bson_opts = opts.select{|k,v| v.is_a?(BSON::ObjectId)}
            bson_opts.map{|k,v| bson_opts[k] = v.to_s}
            opts.merge!(bson_opts)
            super(opts, *rest)
          end

        end

      end
    end
  end
end
