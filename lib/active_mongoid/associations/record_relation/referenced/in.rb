module ActiveMongoid
  module Associations
    module RecordRelation
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
            return replacement if replacement.is_a?(::ActiveRecord::Base)
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
              "id"
            end

            def macro
              :belongs_to_record
            end

            def builder(base, meta, object)
              ActiveMongoid::Associations::Builders::In.new(base, meta, object)
            end

            def criteria(metadata, object, type = nil)
              assoc = type.where(metadata.primary_key => object)
              assoc = assoc.instance_exec(&metadata.scope) if metadata.scope?
              assoc
            end

          end

        end
      end
    end
  end
end
