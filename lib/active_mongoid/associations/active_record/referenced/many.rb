module ActiveMongoid
  module Associations
    module ActiveRecord
      module Referenced
        class Many < Associations::Many

          delegate :count, to: :criteria
          delegate :first, :in_memory, :last, :reset, :uniq, to: :target

          def <<(*args)
            docs = args.flatten
            return concat(docs) if docs.size > 1
            if doc = docs.first
              append(doc)
              doc.save if base.persisted?
            end
            self
          end
          alias :push :<<

          def concat(documents)
            docs, inserts = [], []
            documents.each do |doc|
              next unless doc
              append(doc)
              save_or_delay(doc, docs, inserts) if base.persisted?
            end
            persist_delayed(docs, inserts)
            self
          end

          def build(attributes = {}, type = nil)
            doc = (type || klass).new(attributes)
            append(doc)
            yield(doc) if block_given?
            doc
          end
          alias :new :build

          def delete(document)
            target.delete(document) do |doc|
              unbind_one(doc) if doc
              cascade!(doc)
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
              target.each { |doc| yield(doc) }
            else
              to_enum
            end
          end

          def exists?
            criteria.exists?
          end

          def find(*args)
            matching = criteria.find(*args)
            Array(matching).each { |doc| target.push(doc) }
            matching
          end

          def initialize(base, target, metadata)
            init(base, ActiveMongoid::Associations::Targets::Enumerable.new(target), metadata) do
            end
          end

          def nullify
            criteria.update_all(__metadata__.foreign_key => nil)
            target.clear do |doc|
              unbind_one(doc)
              doc.changed_attributes.delete(__metadata__.foreign_key)
            end
          end
          alias :nullify_all :nullify


          def purge
            unless __metadata__.destructive?
              nullify
            else
              after_remove_error = nil
              criteria.delete_all
              many = target.clear do |doc|
                unbind_one(doc)
                doc.destroyed = true
              end
              many
            end
          end
          alias :clear :purge

          def substitute(replacement)
            if replacement
              new_docs, docs = replacement.compact, []
              new_ids = new_docs.map { |doc| doc.id }
              remove_not_in(new_ids)
              new_docs.each do |doc|
                docs.push(doc) if doc.send(__metadata__.foreign_key) != base.id
              end
              concat(docs)
            else
              purge
            end
            self
          end

          def unscoped
            klass.unscoped.where(__metadata__.foreign_key => base.id)
          end

          private

          def append(document)
            target.push(document)
            # characterize_one(document)
            bind_one(document)
          end

          def binding
            Bindings::Many.new(base, target, __metadata__)
          end


          def collection
            klass.collection
          end

          def criteria
            Many.criteria(__metadata__, base.send(__metadata__.primary_key), base.class)
          end

          def cascade!(document)
            if base.persisted?
              if __metadata__.destructive?
                document.send(__metadata__.dependent)
              else
                document.save
              end
            end
          end

          def method_missing(name, *args, &block)
            if target.respond_to?(name)
              target.send(name, *args, &block)
            else
              klass.send(:with_scope, criteria) do
                criteria.public_send(name, *args, &block)
              end
            end
          end

          # TODO: look into AR analog to collection insert
          def persist_delayed(docs, inserts)
            unless docs.empty?
              collection.insert(inserts)
              docs.each do |doc|
                doc.new_record = false
                doc.post_persist
              end
            end
          end

          def remove_all(conditions = nil, method = :delete_all)
            selector = conditions || {}
            removed = klass.send(method, selector.merge!(criteria.selector))
            target.delete_if do |doc|
              if doc.matches?(selector)
                unbind_one(doc) and true
              end
            end
            removed
          end

          def remove_not_in(ids)
            removed = criteria.not_in(_id: ids)
            if __metadata__.destructive?
              removed.delete_all
            else
              removed.update_all(__metadata__.foreign_key => nil)
            end
            in_memory.each do |doc|
              if !ids.include?(doc.id)
                unbind_one(doc)
                target.delete(doc)
                if __metadata__.destructive?
                  doc.destroyed = true
                end
              end
            end
          end

          def save_or_delay(doc, docs, inserts)
            if doc.new_record? && doc.valid?(:create)
              doc.run_before_callbacks(:save, :create)
              docs.push(doc)
              inserts.push(doc.as_document)
            else
              doc.save
            end
          end

          class << self

            def stores_foreign_key?
              false
            end

            def foreign_key(name)
              "#{name}#{foreign_key_suffix}"
            end

            def foreign_key_default
              nil
            end

            def foreign_key_suffix
              "_id"
            end

            def primary_key_default
              "id"
            end

            def macro
              :has_many_documents
            end

            def builder(base, meta, object)
              ActiveMongoid::Associations::Builders::Many.new(base, meta, object || [])
            end

            def criteria(metadata, object, type = nil)
              metadata.klass.where(metadata.foreign_key => object)
            end

          end

        end
      end
    end
  end
end
