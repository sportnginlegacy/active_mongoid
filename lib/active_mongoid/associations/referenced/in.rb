module ActiveMongoid
  module Associations
    module Referenced
      class In < Associations::One

        def initialize(base, target, metadata)
          init(base, target, metadata) do
          end
        end


        class << self

          def stores_foreign_key?
            true
          end

          def foreign_key(name)
            "#{name}#{foreign_key_suffix}"
          end

          def foreign_key_default
            nil
          end

          def foreign_key_suffix
            "_id"
          end

          def builder(base, meta, object)
            Builders::In.new(base, meta, object)
          end

          def criteria(metadata, object, type = nil)
            type.where(metadata.primary_key => object)
          end

        end

      end
    end
  end
end
