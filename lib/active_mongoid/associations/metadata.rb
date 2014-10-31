module ActiveMongoid
  module Associations
    class Metadata < Hash

      delegate :primary_key_default, :foreign_key_default, :stores_foreign_key?, :macro, to: :relation

      def as
        self[:as]
      end

      def as?
        !!as
      end

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

      def order
        self[:order]
      end

      def criteria(object, type = nil)
        query = relation.criteria(self, object, type)
        if order
          query = query.respond_to?(:order_by) ? query.order_by(order) : query.order(order)
        end
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

      def type_setter
        @type_setter ||= "#{type}="
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
        class_name.constantize
      end
      alias_method :klass, :object_class

      def class_name
        (self[:class_name] || name.to_s.singularize.titleize.delete(' ')).sub(/\A::/,"")
      end

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
        @inverse_klass ||= inverse_class_name.constantize if inverse_class_name
      end

      def inverse_class_name
        self[:as] || self[:inverse_class_name]
      end

      def inverses(other = nil)
        if self[:polymorphic]
          lookup_inverses(other)
        else
          @inverses ||= determine_inverses
        end
      end

      def polymorphic?
        @polymorphic ||= (!!self[:as] || !!self[:polymorphic])
      end

      def lookup_inverses(other)
        return [ inverse_of ] if inverse_of
        if other
          matches = []
          other.class.am_relations.values.each do |meta|
            if meta.as.to_s == name && meta.class_name == inverse_class_name
              matches.push(meta.name)
            end
          end
          matches
        end
      end

      def determine_inverse_for(field)
        relation.stores_foreign_key? && polymorphic? ? "#{name}_#{field}" : nil
      end

      def inverse_type
        @inverse_type ||= determine_inverse_for(:type)
      end

      def inverse(other = nil)
        invs = inverses(other)
        invs.first if invs.count == 1
      end

      def inverse_of
        self[:inverse_of]
      end

      def inverse_setter(other = nil)
        "#{inverse(other)}="
      end

      def inverse_metadata(object = nil)
        object = object || object_class
        object.reflect_on_am_association(inverse(object))
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
        klass.am_relations.each_pair do |key, meta|
          next if meta.name == name
          if meta.class_name == inverse_class_name
            return key.to_sym
          end
        end
        return nil
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

      def polymorphic?
        @polymorphic ||= (!!self[:as] || !!self[:polymorphic])
      end

      def type
        @type ||= polymorphic? ? "#{as}_type" : nil
      end

      def type_setter
        @type_setter ||= "#{type}="
      end

      def determine_inverse_for(field)
        relation.stores_foreign_key? && polymorphic? ? "#{name}_#{field}" : nil
      end

      def inverse_type
        @inverse_type ||= determine_inverse_for(:type)
      end

      def inverse_type_setter
        @inverse_type_setter ||= "#{inverse_type}="
      end

    end
  end
end
