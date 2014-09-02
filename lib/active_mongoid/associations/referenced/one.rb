module ActiveMongoid
  module Associations
    module Referenced
      class One < Associations::One

        def initialize(base, target, metadata)
          init(base, target, metadata) do
          end
        end

        class << self

          def stores_foreign_key?
            false
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
            Builders::One.new(base, meta, object)
          end

          def criteria(metadata, object, type = nil)
            metadata.klass.where(metadata.foreign_key => object)
          end

        end

      end
    end
  end
end
