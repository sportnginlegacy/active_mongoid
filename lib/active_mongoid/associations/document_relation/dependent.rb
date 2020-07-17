module ActiveMongoid
  module Associations
    module DocumentRelation
      module Dependent
        extend ActiveSupport::Concern

        module ClassMethods

          def dependent_documents(metadata)
            if metadata.dependent
              dependent_method = :"dependent_documents_for_#{metadata.name}"
              define_method(dependent_method) do
                if metadata.dependent.to_sym == :delete_all
                  type = attributes[metadata.inverse_type]
                  target = metadata.builder(self, send(metadata.key)).build(type)
                  target.delete_all
                else
                  relation = get_document_relation(metadata.name, metadata, nil, true)
                  Array(relation).each { |d| d.send(metadata.dependent) }
                end
              end

              before_destroy dependent_method
            end
          end

        end

      end
    end
  end
end
