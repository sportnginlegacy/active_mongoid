module ActiveMongoid
  module Associations
    class Binding

      attr_reader :base, :target, :__metadata__

      def initialize(base, target, metadata)
        @base = base
        @target = target
        @__metadata__ = metadata
      end


    end
  end
end
