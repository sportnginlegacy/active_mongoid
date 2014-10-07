module ActiveMongoid
  class FinderProxy
    instance_methods.each do |method|
      undef_method(method) unless method =~ /(^__|^object_id|^tap)/
    end

    attr_accessor :__target
    attr_accessor :__target_class


    def initialize(target)
      @__target = target
      @__target_class = target.respond_to?(:klass) ? target.klass : target
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
      if opts && opts.is_a?(Hash)
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

    def method_missing(name, *args, &block)
      resp = __target.send(name, *args, &block)
      if resp == __target_class || (resp.is_a?(ActiveRecord::Relation) && resp.klass == __target_class)
        FinderProxy.new(resp)
      else
        resp
      end
    end

  end
end
