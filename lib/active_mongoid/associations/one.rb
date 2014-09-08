module ActiveMongoid
  module Associations
    class One < Proxy

      def clear
        target.delete
      end

      def respond_to?(name, include_private = false)
        target.respond_to?(name, include_private) || super
      end

      def ==(other)
        return false unless other
        return true if target.object_id == other.object_id
        return true if target.attributes == other.attributes
        target == other
      end
    end
  end
end
