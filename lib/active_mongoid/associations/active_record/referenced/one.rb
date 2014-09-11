module ActiveMongoid
  module Associations
    module ActiveRecord
      module Referenced
        class One < Associations::One

          def initialize(base, target, metadata)
            init(base, target, metadata) do
              bind_one
            end
          end

          def substitute(replacement)
            unbind_one
            if base.persisted?
              if __metadata__.destructive?
                send(__metadata__.dependent)
              else
                save if persisted?
              end
            end
            One.new(base, replacement, __metadata__) if replacement
          end

          private

          def binding
            Bindings::One.new(base, target, __metadata__)
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

            def primary_key_default
              "id"
            end

            def macro
              :has_one_document
            end

            def builder(base, meta, object)
              ActiveMongoid::Associations::Builders::One.new(base, meta, object)
            end

            def criteria(metadata, object, type = nil)
              with_polymorphic_criterion(
                metadata.klass.where(metadata.foreign_key => object),
                metadata,
                type)
            end

            def with_polymorphic_criterion(criteria, metadata, type = nil)
              if metadata.polymorphic?
                criteria.where(metadata.type => type.name)
              else
                criteria
              end
            end

          end

        end
      end
    end
  end
end
