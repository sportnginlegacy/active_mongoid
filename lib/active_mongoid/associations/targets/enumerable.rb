require 'mongoid'

module ActiveMongoid
  module Associations
    module Targets
      class Enumerable
        include ::Enumerable

        attr_accessor :added, :loaded, :unloaded

        delegate :===, :is_a?, :kind_of?, :to => :added

        def ==(other)
          return false unless other.respond_to?(:entries)
          entries == other.entries
        end

        def <<(document)
          added.push(document)
        end
        alias :push :<<

        def clear
          if block_given?
            in_memory { |doc| yield(doc) }
          end
          loaded.clear and added.clear
        end

        def clone
          collect { |doc| doc.clone }
        end

        def delete(document)
          (loaded.delete_one(document) || added.delete_one(document)).tap do |doc|
            unless doc
              key = document.is_a?(::Mongoid::Document) ? :_id : :id
              if unloaded && unloaded.where(key => document.id).exists?
                yield(document) if block_given?
                return document
              end
            end
            yield(doc) if block_given?
          end
        end

        def delete_if(&block)
          load_all!
          tap do
            loaded.delete_if(&block)
            added.delete_if(&block)
          end
        end

        def each
          if loaded?
            loaded.each do |doc|
              yield(doc)
            end
          else
            unloaded.each do |doc|
              document = added.delete(doc) || loaded.delete(doc) || doc
              yield(document)
              loaded.push(document)
            end
          end
          added.each do |doc|
            yield(doc)
          end
          @executed = true
        end

        def empty?
          if loaded?
            in_memory.count == 0
          else
            unloaded.count + added.count == 0
          end
        end

        def first
          added.first || (loaded? ? loaded.first : unloaded.first)
        end

        def initialize(target)
          if target.is_a?(::Mongoid::Criteria) || target.is_a?(::ActiveRecord::Relation)
            @added, @loaded, @unloaded = [], [], target
          else
            @added, @executed, @loaded = [], true, target
          end
        end

        def inspect
          entries.inspect
        end

        def in_memory
          (loaded + added).tap do |docs|
            docs.each { |doc| yield(doc) } if block_given?
          end
        end

        def last
          added.last || (loaded? ? loaded.last : unloaded.last)
        end

        alias :load_all! :entries

        def loaded?
          !!@executed
        end

        def reset
          loaded.clear and added.clear
          @executed = false
        end

        def respond_to?(name, include_private = false)
          [].respond_to?(name, include_private) || super
        end

        def size
          count = (unloaded ? unloaded.count : loaded.count)
          if count.zero?
            count + added.count
          else
            count + added.count{ |d| d.new_record? }
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

        def where(opts = :chain, *rest)
          if unloaded.is_a?(::Mongoid::Criteria) || unloaded.is_a?(::ActiveRecord::Relation)
            unloaded.where(opts, *rest)
          else
            raise NoMethodError
          end
        end

        private

        def method_missing(name, *args, &block)
          entries.send(name, *args, &block)
        end

      end
    end
  end
end
