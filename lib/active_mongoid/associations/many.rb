module ActiveMongoid
  module Associations
    class Many < Proxy

      delegate :avg, :max, :min, :sum, to: :criteria
      delegate :length, :size, to: :target
      delegate :count, to: :criteria
      delegate :first, :in_memory, :last, :reset, :uniq, to: :target

      def initialize(base, target, metadata)
        init(base, ActiveMongoid::Associations::Targets::Enumerable.new(target), metadata) do
        end
      end

      def <<(*args)
        objs = args.flatten
        return concat(objs) if objs.size > 1
        if objs = objs.first
          append(objs)
          objs.save if base.persisted? && !_assigning?
        end
        self
      end
      alias :push :<<

      def build(attributes = {}, type = nil)
        obj = (type || klass).new(attributes)
        append(obj)
        yield(obj) if block_given?
        obj
      end
      alias :new :build

      def concat(objects)
        objs, inserts = [], []
        objects.each do |obj|
          next unless obj
          append(obj)
          save_or_delay(obj, objs, inserts) if base.persisted?
        end
        persist_delayed(objs, inserts)
        self
      end

      def purge
        unless __metadata__.destructive?
          nullify
        else
          after_remove_error = nil
          criteria.delete_all
          many = target.clear do |obj|
            unbind_one(obj)
            obj.destroyed = true if obj.respond_to?(:destroyed=)
          end
          many
        end
      end
      alias :clear :purge

      def delete(object)
        target.delete(object) do |obj|
          unbind_one(obj) if obj
          cascade!(obj) if obj
        end
      end

      def delete_all(conditions = nil)
        remove_all(conditions, :delete_all)
      end

      def destroy_all(conditions = nil)
        remove_all(conditions, :destroy_all)
      end

      def each
        if block_given?
          target.each { |obj| yield(obj) }
        else
          to_enum
        end
      end

      def exists?
        criteria.exists?
      end

      def find(*args)
        begin
          matching = criteria.find(*args)
        rescue Exception => e
        end
        Array(matching).each { |obj| target.push(obj) }
        matching
      end

      def nullify
        criteria.update_all(__metadata__.foreign_key => nil)
        target.clear do |obj|
          unbind_one(obj)
          obj.changed_attributes.delete(__metadata__.foreign_key)
        end
      end
      alias :nullify_all :nullify

      def blank?
        size == 0
      end

      def create(attributes = nil, type = nil, &block)
        if attributes.is_a?(::Array)
          attributes.map { |attrs| create(attrs, type, &block) }
        else
          obj = build(attributes, type, &block)
          base.persisted? ? obj.save : raise_unsaved(obj)
          obj
        end
      end

      def create!(attributes = nil, type = nil, &block)
        if attributes.is_a?(::Array)
          attributes.map { |attrs| create!(attrs, type, &block) }
        else
          obj = build(attributes, type, &block)
          base.persisted? ? obj.save! : raise_unsaved(obj)
          obj
        end
      end

      def find_or_create_by(attrs = {}, type = nil, &block)
        find_or(:create, attrs, type, &block)
      end

      def find_or_initialize_by(attrs = {}, type = nil, &block)
        find_or(:build, attrs, type, &block)
      end

      def nil?
        false
      end

      def respond_to?(name, include_private = false)
        [].respond_to?(name, include_private) ||
          klass.respond_to?(name, include_private) || super
      end

      def scoped
        criteria
      end

      def unscoped
        criteria.unscoped
      end

      def raise_unsaved(obj)
        # raise new exception
      end

      def substitute(replacement)
        if replacement
          new_objs, objs = replacement.compact, []
          new_ids = new_objs.map { |obj| obj.id }
          remove_not_in(new_ids)
          new_objs.each do |obj|
            objs.push(obj) if obj.send(__metadata__.foreign_key) != base.id
          end
          concat(objs)
        else
          purge
        end
        self
      end

      def unscoped
        klass.unscoped.where(__metadata__.foreign_key => base.id)
      end

      private

      def find_or(method, attrs = {}, type = nil, &block)
        attrs["_type"] = type.to_s if type
        where(attrs).first || send(method, attrs, type, &block)
      end

      def append(object)
        target.push(object)
        # characterize_one(object)
        bind_one(object)
      end

      def cascade!(object)
        if base.persisted?
          if __metadata__.destructive?
            object.send(__metadata__.dependent)
          else
            object.save
          end
        end
      end

      def with_polymorphic_criterion(criteria, metadata, type = nil)
        if metadata.polymorphic?
          criteria.where(metadata.type => type.name)
        else
          criteria
        end
      end

    end
  end
end
