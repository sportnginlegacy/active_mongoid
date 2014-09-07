module ActiveMongoid
  module Associations
    module ActiveRecord
      module Referenced
        class In < Associations::One

          def initialize(base, target, metadata)
            init(base, target, metadata) do
              bind_one
            end
          end

          def substitute(replacement)
            unbind_one
            return nil unless replacement
            self.target = normalize(replacement)
            bind_one
            self
          end

          private

          def binding
            Bindings::In.new(base, target, __metadata__)
          end

          def normalize(replacement)
            return replacement if replacement.is_a?(::Mongoid::Document)
            __metadata__.builder(klass, replacement).build
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

            def primary_key_default
              "_id"
            end

            def builder(base, meta, object)
              ActiveMongoid::Associations::Builders::In.new(base, meta, object)
            end

            def criteria(metadata, object, type = nil)
              type.where(metadata.primary_key => object)
            end

          end

        end
      end
    end
  end
end
