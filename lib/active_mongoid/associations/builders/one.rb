module ActiveMongoid
  module Associations
    module Builders
      class One < Builder

        def build(type = nil)
          return object unless query?
          return nil if base.new_record?
          __metadata__.criteria(object, base.class).first
        end

      end
    end
  end
end
