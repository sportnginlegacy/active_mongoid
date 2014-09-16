module ActiveMongoid
  module Associations
    class Metadata < Hash

      delegate :primary_key_default, :foreign_key_default, :stores_foreign_key?, :macro, to: :relation

      def initialize(properties = {})
        merge!(properties)
      end

      def autosave
        self[:autosave]
      end

      def autosave?
        !!autosave
      end

      def builder(base, object)
        relation.builder(base, self, object)
      end

      def criteria(object, type = nil)
        query = relation.criteria(self, object, type)
        # order ? query.order_by(order) : query
        query
      end

      def key
        relation.stores_foreign_key? ? foreign_key : primary_key
      end

      def foreign_key
        @foreign_key ||= determine_foreign_key
      end

      def foreign_key_setter
        @foreign_key_setter ||= "#{foreign_key}="
      end

      def determine_key
        relation.stores_foreign_key? ? foreign_key : primary_key
      end

      def primary_key
        @primary_key ||= (self[:primary_key] || primary_key_default)
      end

      def determine_foreign_key
        return self[:foreign_key].to_s if self[:foreign_key]

        if relation.stores_foreign_key?
          relation.foreign_key(name)
        else
          inverse_metadata.foreign_key
        end
      end

      def object_class
        (self[:class_name] || name.to_s.singularize.titleize.delete(' ')).constantize
      end
      alias_method :klass, :object_class

      def name
        self[:name].to_s
      end

      def object_name
        name.to_s.singularize
      end

      def plural_anme
        name.to_s.pluralize
      end

      def relation
        self[:relation]
      end

      def inverse_klass
        @inverse_klass ||= inverse_class_name.constantize
      end

      def inverse_class_name
        self[:as] || self[:inverse_class_name]
      end

      def inverses(other = nil)
        if self[:polymorphic]
          # lookup_inverses(other)
        else
          @inverses ||= determine_inverses
        end
      end

      def inverse(other = nil)
        invs = inverses(other)
        invs.first if invs.count == 1
      end


      def inverse_setter
        "#{inverse}="
      end

      def inverse_metadata
        object_class.am_relations[inverse]
      end

      def determine_inverses
        return [ inverse_of ] if has_key?(:inverse_of)
        return [ as ] if has_key?(:as)
        [ inverse_relation ]
      end

      def inverse_relation
        @inverse_relation ||= determine_inverse_relation
      end

      def determine_inverse_relation
        default = foreign_key_match || klass.am_relations[inverse_klass.name.underscore]
        return default.name if default
        # TODO: raise exception
      end

      def foreign_key_match
        if fk = self[:foreign_key]
          relations_metadata.detect do |meta|
            fk == meta.foreign_key if meta.stores_foreign_key?
          end
        end
      end

      def relations_metadata
        klass.am_relations.values
      end

      def dependent
        self[:dependent]
      end

      def destructive?
        @destructive ||= (dependent == :delete || dependent == :destroy)
      end


    end
  end
end
