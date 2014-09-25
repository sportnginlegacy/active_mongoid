module ActiveMongoid
  module Associations
    module RecordRelation
      module Bindings
        class Many < Associations::Binding

          def bind_one(doc)
            bind_from_relational_parent(doc)
          end

          def unbind_one(doc)
            unbind_from_relational_parent(doc)
          end

        end
      end
    end
  end
end
