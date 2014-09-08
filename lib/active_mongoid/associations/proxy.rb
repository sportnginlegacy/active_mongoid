module ActiveMongoid
  module Associations
    class Proxy

      instance_methods.each do |method|
        undef_method(method) unless
          method =~ /(^__|^send|^object_id|^respond_to|^tap)/
      end

      delegate :bind_one, :unbind_one, to: :binding

      attr_accessor :base, :target, :__metadata__

      def init(base, target, metadata)
        @base = base
        @target = target
        @__metadata__ = metadata
        yield(self) if block_given?
      end

      def method_missing(name, *args, &block)
        target.send(name, *args, &block)
      end

      def klass
        __metadata__ ? __metadata__.klass : nil
      end

      def ==(other)
        # return false unless other
        # return true if target.object_id == other.object_id
        # return true if target.attributes == other.attributes
        target == other
      end

    end
  end
end
