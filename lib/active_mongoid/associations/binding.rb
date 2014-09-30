require 'mongoid/threaded'

module ActiveMongoid
  module Associations
    class Binding
      include ::Mongoid::Threaded::Lifecycle

      attr_reader :base, :target, :__metadata__

      def initialize(base, target, metadata)
        @base = base
        @target = target
        @__metadata__ = metadata
      end

      private

      def check_inverse!(object)
        # check for inverse relation and raise exception when not
        true
      end

      def bind_foreign_key(base, id)
        return if base.send(__metadata__.foreign_key) == id
        base.send(__metadata__.foreign_key_setter, id)
      end

      def bind_inverse(object, inverse)
        if object.respond_to?(__metadata__.inverse_setter)
          object.send(__metadata__.inverse_setter, inverse)
        end
      end

      def record_id(base)
        base.send(__metadata__.primary_key)
      end

      def set_base_metadata
        inverse_metadata = __metadata__.inverse_metadata
        if inverse_metadata != __metadata__ && !inverse_metadata.nil?
          base.__metadata__ = inverse_metadata
        end
        true
      end

      def bind_from_relational_parent(object)
        check_inverse!(object)
        bind_foreign_key(object, record_id(base))
        unless _binding?
          _binding do
            bind_inverse(object, base)
          end
        end
      end

      def unbind_from_relational_parent(object)
        check_inverse!(object)
        bind_foreign_key(object, nil)
        # bind_polymorphic_type(object, nil)
        unless _binding?
          _binding do
            bind_inverse(object, nil)
          end
        end
      end

    end
  end
end
