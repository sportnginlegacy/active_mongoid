module ActiveMongoid
  module Finders
    extend ActiveSupport::Concern

    module ClassMethods

      def find(*args)
        key = args.flatten.first
        if !key.is_a?(Fixnum) && (key.is_a?(BSON::ObjectId) || BSON::ObjectId.legal?(key))
          where({_id: key.to_s}).first.tap do |obj|
            raise ActiveRecord::RecordNotFound unless obj
          end
        else
          FinderProxy.new(super(*args))
        end
      end

      def where(opts = :chain, *rest)
        unless opts.is_a?(String)
          bson_opts = opts.select{|k,v| v.is_a?(BSON::ObjectId)}

          if bson_opts[:id]
            opts.delete(:id)
            bson_opts[:_id] = bson_opts.delete(:id)
          end

          bson_opts.each do |k,v|
            bson_opts[k] = v.to_s
          end

          opts.merge!(bson_opts)
        end
        FinderProxy.new(super(opts, *rest))
      end

      def includes(*args)
        FinderProxy.new(super(*args))
      end

      def scoped(options = nil)
        FinderProxy.new(super(options))
      end

      def merge(options = nil)
        FinderProxy.new(super(options))
      end

    end
  end
end
