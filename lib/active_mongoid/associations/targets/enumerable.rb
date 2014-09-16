require 'mongoid'

module ActiveMongoid
  module Associations
    module Targets
      class Enumerable
        include ::Enumerable

        attr_accessor :_added, :_loaded, :_unloaded

        delegate :is_a?, :kind_of?, to: []

        def ==(other)
          return false unless other.respond_to?(:entries)
          entries == other.entries
        end

        def ===(other)
          other.class == Class ? Array == other : self == other
        end

        def <<(document)
          id = document.id || document.object_id
          _added[id] = document
          self
        end
        alias :push :<<

         def clear
          if block_given?
            in_memory { |doc| yield(doc) }
          end
          _loaded.clear and _added.clear
        end

        def clone
          collect { |doc| doc.clone }
        end

        def delete(document)
          doc = (_loaded.delete(document.id) || _added.delete(document.id) || _added.delete(document.object_id) )
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
            _loaded.delete(doc.id)
            _added.delete(doc.id)
            _added.delete(doc.object_id)
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
              document = _added.delete(doc.id) || _added.delete(doc.object_id) || _loaded.delete(doc.id) || doc
              _loaded[document.id] = document
              yield(document)
            end
          end
          _added.each_pair do |id, doc|
            yield(doc)
          end
          @executed = true
        end

        def empty?
          if _loaded?
            in_memory.count == 0
          else
            _unloaded.count + _added.count == 0
          end
        end

        def first
          matching_document(:first)
        end

        def initialize(target)
          if target.is_a?(::Mongoid::Criteria || ::ActiveRecord::Relation)
            @_added, @executed, @_loaded, @_unloaded = {}, false, {}, target
          else
            @_added, @executed = {}, true
            @_loaded = target.inject({}) do |_target, doc|
              _target[doc.id] = doc
              _target
            end
          end
        end

        def include?(doc)
          return super unless _unloaded
          id = doc.id || doc.object_id
          _unloaded.where(_id: doc.id).exists? || _added.has_key?(doc.id) || _added.has_key?(doc.object_id)
        end

        def inspect
          entries.inspect
        end

        def in_memory
          docs = (_loaded.values + _added.values)
          docs.each { |doc| yield(doc) } if block_given?
          docs
        end

        def last
          matching_document(:last)
        end

        alias :load_all! :entries

        def _loaded?
          !!@executed
        end

        def marshal_dump
          [ _added, _loaded, _unloaded ]
        end

        def marshal_load(data)
          @_added, @_loaded, @_unloaded = data
        end

        def reset
          _loaded.clear and _added.clear
          @executed = false
        end

        def reset_unloaded(criteria)
          @_unloaded = criteria if _unloaded.is_a?(::Mongoid::Criteria || ::ActiveRecord::Relation)
        end

        def respond_to?(name, include_private = false)
          [].respond_to?(name, include_private) || super
        end

        def size
          count = (_unloaded ? _unloaded.count : _loaded.count)
          if count.zero?
            count + _added.count
          else
            count + _added.values.count{ |d| d.new_record? }
          end
        end
        alias :length :size

        def to_json(options = {})
          entries.to_json(options)
        end

        def as_json(options = {})
          entries.as_json(options)
        end

        def uniq
          entries.uniq
        end

        private

        def method_missing(name, *args, &block)
          entries.send(name, *args, &block)
        end

        def matching_document(location)
          _loaded.try(:values).try(location) ||
            _added[(ul = _unloaded.try(location)).try(:id)] ||
            ul ||
            _added.values.try(location)
        end

        def unloaded_documents
          blank_criteria?(_unloaded) ? [] : _unloaded
        end

        def blank_criteria?(_unloaded)
          if _unloaded.is_a?(::Mongoid::Criteria)
            _unloaded.selector.values.any?{|v| v == { "_id" => { "$in" => [] }} }
          elsif _unloaded.is_a?(::ActiveRecord::Relation)
            false
          else
            false
          end
        end

      end
    end
  end
end
