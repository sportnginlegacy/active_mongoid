module ActiveMongoid
  module Associations
    module ActiveRecord
      module Bindings
        class In < Associations::Binding

          def bindle_one
            check_inverse!(target)
            bind_foreign_key(base, record_id(target))
            if inverse = __metadata__.inverse
              if set_base_metadata
                target.set_document_relation(inverse, base)
              end
            end
          end

          def unbind_one
            inverse = __metadata__.inverse(target)
            bind_foreign_key(base, nil)
            if inverse
              set_base_metadata
              target.set_document_relation(inverse, nil)
            end
          end

        end
      end
    end
  end
end
