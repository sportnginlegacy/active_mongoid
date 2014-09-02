module ActiveMongoid
  module Associations
    module Referenced
      module Builders
        class One < Builder

          def build(type = nil)
            return object unless query?
            model = type ? type.constantize : metadata.klass
            metadata.criteria(object, model).first
          end

        end
      end
    end
  end
end
