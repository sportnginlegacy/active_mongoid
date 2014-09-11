module ActiveMongoid
  module Associations
    module Mongoid
      module Bindings
        class In < Associations::Binding

          def bind_one
            check_inverse!(target)
            bind_foreign_key(base, record_id(target))
            if inverse = __metadata__.inverse
              if set_base_metadata
                if base.referenced_many_records?
                  target.__send__(inverse).push(base)
                else
                  target.set_document_relation(inverse, base)
                end
              end
            end
          end

          def unbind_one
            inverse = __metadata__.inverse
            bind_foreign_key(base, nil)
            if inverse
              set_base_metadata
              if base.referenced_many_records?
                target.__send__(inverse).delete(base)
              else
                target.set_document_relation(inverse, nil)
              end
            end
          end

        end
      end
    end
  end
end
