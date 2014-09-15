module ActiveMongoid
  module Associations
    module ActiveRecord
      module Dependent
        extend ActiveSupport::Concern

        module ClassMethods

          def dependent_documents(metadata)
            if metadata.dependent
              dependent_method = :"dependent_documents_for_#{metadata.name}"
              define_method(dependent_method) do
                relation = get_document_relation(metadata.name, metadata, nil, true)
                Array(relation).each { |d| d.send(metadata.dependent) }
              end

              before_destroy dependent_method
            end
          end

        end

      end
    end
  end
end
