require 'mongoid'

module ActiveMongoid
  module Associations
    module Targets
      class Enumerable < ::Mongoid::Relations::Targets::Enumerable

        def <<(document)
          id = document.id || document.object_id
          _added[id] = document
          self
        end
        alias :push :<<

        def delete(document)
          id = document.id || document.object_id
          doc = (_loaded.delete(document.id) || _added.delete(id))
          unless doc
            if _unloaded && _unloaded.where(_id: document.id).exists?
              yield(document) if block_given?
              return document
            end
          end
          yield(doc) if block_given?
          doc
        end

        def delete_if(&block)
          load_all!
          deleted = in_memory.select(&block)
          deleted.each do |doc|
            id = doc.id || doc.object_id
            _loaded.delete(doc.id)
            _added.delete(id)
          end
          self
        end

        def each
          unless block_given?
            return to_enum
          end
          if _loaded?
            _loaded.each_pair do |id, doc|
              yield(doc)
            end
          else
            unloaded_documents.each do |doc|
              id = doc.id || doc.object_id
              document = _added.delete(doc.id) || _loaded.delete(id) || doc
              _loaded[document.id] = document
              yield(document)
            end
          end
          _added.each_pair do |id, doc|
            yield(doc)
          end
          @executed = true
        end

        def include?(doc)
          return super unless _unloaded
          id = doc.id || doc.object_id
          _unloaded.where(_id: doc.id).exists? || _added.has_key?(doc.id)
        end


      end
    end
  end
end
