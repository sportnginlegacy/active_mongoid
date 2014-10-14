module ActiveMongoid
  class FinderProxy
    instance_methods.each do |method|
      undef_method(method) unless method =~ /(^__|^object_id|^tap)/
    end

    attr_accessor :__target

    def initialize(target)
      @__target = target
    end

    def find(*args)
      key = args.flatten.first
      if !key.is_a?(Fixnum) && (key.is_a?(BSON::ObjectId) || BSON::ObjectId.legal?(key))
        where({_id: key.to_s}).first.tap do |obj|
          raise ActiveRecord::RecordNotFound unless obj
        end
      else
        FinderProxy.new(__target.send(:find, *args))
      end
    end

    def where(opts = :chain, *rest)
      if opts && opts.respond_to?(:select)
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
      FinderProxy.new(__target.send(:where, opts, *rest))
    end

    def includes(*args)
      FinderProxy.new(__target.send(:includes, *args))
    end

    def scoped(options = nil)
      FinderProxy.new(__target.send(:scoped, options))
    end

    def merge(options = nil)
      FinderProxy.new(__target.send(:merge, options))
    end

    def method_missing(name, *args, &block)
      __target.send(name, *args, &block)
    end

  end
end
