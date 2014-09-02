module ActiveMongoid
  module Associations
    module Mongoid
      module Macros
        extend ActiveSupport::Concern

        module ClassMethods

          def belongs_to_record(name, options = {})
            meta = characterize_association(name, Referenced::In, options)
            relate_record(name, meta)
          end

          private

          def reference_record(metadata)
            key = metadata.foreign_key
            if metadata.stores_foreign_key? && !fields.include?(key)
              field(
                key,
                type: Integer,
                default: metadata.foreign_key_default
              )
            end
          end

          def relate_record(name, metadata)
            self.am_relations = am_relations.merge(name.to_s => metadata)
            reference_record(metadata)
            record_getter(name, metadata)
            record_setter(name, metadata)
            existence_check(name)
          end

        end
      end

    end
  end
end
