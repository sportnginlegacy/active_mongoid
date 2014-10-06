module ActiveMongoid
  module Finders
    extend ActiveSupport::Concern

    module ClassMethods

      def am_scoped
        FinderProxy.new(self)
      end

    end
  end
end
