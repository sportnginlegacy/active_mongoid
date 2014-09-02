module ActiveMongoid
  module Associations
    class Proxy

      instance_methods.each do |method|
        undef_method(method) unless
          method =~ /(^__|^send|^object_id|^respond_to|^tap)/
      end


      attr_accessor :base, :target

      def init(base, target, metadata)
        @base = base
        @target = target
        yield(self) if block_given?
      end

      def method_missing(name, *args, &block)
        target.send(name, *args, &block)
      end

      protected

    end
  end
end
