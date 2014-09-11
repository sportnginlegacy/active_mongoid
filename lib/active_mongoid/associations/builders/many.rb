module ActiveMongoid
  module Associations
    module Builders
      class Many < Builder

        def build(type = nil)
          return object unless query?
          model = type ? type.constantize : __metadata__.klass
          __metadata__.criteria(object, model)
        end

      end
    end
  end
end
