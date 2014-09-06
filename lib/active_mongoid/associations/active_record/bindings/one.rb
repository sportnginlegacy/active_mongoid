module ActiveMongoid
  module Associations
    module ActiveRecord
      module Bindings
        class One < Associations::Binding

          def bind_one
            bind_from_relational_parent(target)
          end

          def unbind_one
            unbind_from_relational_parent(target)
          end

        end
      end
    end
  end
end
