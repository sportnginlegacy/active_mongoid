module ActiveMongoid
  module Associations
    module Builders
      class In < Builder

        def build(type = nil)
          return object unless query?
          return nil if object.blank?
          type = type.constantize if type and type.is_a?(String)
          model = type ? type : __metadata__.klass
          __metadata__.criteria(object, model).first
        end

      end
    end
  end
end
