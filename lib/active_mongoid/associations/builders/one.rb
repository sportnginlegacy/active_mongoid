module ActiveMongoid
  module Associations
    module Builders
      class One < Builder

        def build(type = nil)
          return object unless query?
          model = type ? type.constantize : __metadata__.klass
          __metadata__.criteria(object, model).first
        end

      end
    end
  end
end
