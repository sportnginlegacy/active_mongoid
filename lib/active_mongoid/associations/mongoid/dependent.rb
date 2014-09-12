module ActiveMongoid
  module Associations
    module Mongoid
      module Dependent
        extend ActiveSupport::Concern

        module ClassMethods

          def dependent_records(metadata)
            if metadata.dependent
              dependent_method = :"dependent_records_for_#{metadata.name}"
              define_method(dependent_method) do
                relation = get_record_relation(metadata.name, metadata, nil,  true)
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
