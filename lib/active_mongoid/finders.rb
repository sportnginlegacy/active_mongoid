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
          bson_opts.each do |k,v|
            _k = (k == :id) ? :_id : k
            bson_opts[_k] = v.to_s
          end
          opts.merge!(bson_opts)
        end
        FinderProxy.new(super(opts, *rest))
      end

    end
  end
end
