module ActiveMongoid
  module Finders
    extend ActiveSupport::Concern

    module ClassMethods

      def find(*args)
        key = args.flatten.first
        if !key.is_a?(Fixnum) && (key.is_a?(::ActiveMongoid::BSON::ObjectId) || ::ActiveMongoid::BSON::ObjectId.legal?(key))
          where({ar_primary_key => key.to_s}).first.tap do |obj|
            raise ActiveRecord::RecordNotFound unless obj
          end
        else
          FinderProxy.new(super(*args))
        end
      end

      def where(opts = :chain, *rest)
        if opts && opts.respond_to?(:select)
          bson_opts = opts.select{|k,v| v.is_a?(::ActiveMongoid::BSON::ObjectId)}

          if bson_opts[:id] && ar_primary_key != :id
            opts.delete(:id)
            bson_opts[:_id] = bson_opts.delete(:id)
          elsif bson_opts[:_id] && ar_primary_key == :id
            opts.delete(:_id)
            bson_opts[:id] = bson_opts.delete(:_id)
          end

          bson_opts.each do |k,v|
            bson_opts[k] = v.to_s
          end

          opts.merge!(bson_opts)
        end
        FinderProxy.new(super(opts, *rest))
      end

      def scoped(options = nil)
        FinderProxy.new(super(options))
      end

      def includes(*args)
        FinderProxy.new(super(*args))
      end

      def joins(*args)
        FinderProxy.new(super(*args))
      end

      def select(select = nil)
        FinderProxy.new(
          if block_given?
            load_target.select.each { |e| yield e }
          else
            scoped.select(select)
          end
        )
      end

      def ar_primary_key
        if self.respond_to?(:primary_bson_key) && self.primary_bson_key
          self.primary_bson_key
        else
          :_id
        end
      end

    end
  end
end
