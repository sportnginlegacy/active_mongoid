module ActiveMongoid
  module Associations
    class One < Proxy
      def clear
        target.delete
      end

      def respond_to?(name, include_private = false)
        target.respond_to?(name, include_private) || super
      end
    end
  end
end
