module ActiveMongoid
  module Associations
    module Builders
      class Many < Builder

        def build(type = nil)
          return object unless query?
          return [] if object.is_a?(Array)
          __metadata__.criteria(object, base.class)
        end

      end
    end
  end
end
