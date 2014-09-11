module ActiveMongoid
  module Associations
    module Mongoid
      module Bindings
        class Many < Associations::Binding

          def bind_one(record)
            bind_from_relational_parent(record)
          end

          def unbind_one(record)
            unbind_from_relational_parent(record)
          end

        end
      end
    end
  end
end
