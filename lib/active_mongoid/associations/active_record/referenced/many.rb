module ActiveMongoid
  module Associations
    module ActiveRecord
      module Referenced
        class Many < Associations::Many

          private

          def criteria
            Many.criteria(__metadata__, base.send(__metadata__.primary_key), base.class)
          end

          def binding
            Bindings::Many.new(base, target, __metadata__)
          end


          def collection
            klass.collection
          end

          def persist_delayed(docs, inserts)
            unless docs.empty?
              collection.insert(inserts)
              docs.each do |doc|
                doc.new_record = false
                doc.post_persist
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

          def remove_all(conditions = nil, method = :delete_all)
            selector = conditions || {}
            removed = klass.send(method, selector.merge!(criteria.selector))
            target.delete_if do |obj|
              if obj.matches?(selector)
                unbind_one(obj) and true
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
            in_memory.each do |obj|
              if !ids.include?(obj.id)
                unbind_one(obj)
                target.delete(obj)
                if __metadata__.destructive?
                  obj.destroyed = true
                end
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
              with_polymorphic_criterion(
                metadata.klass.where(metadata.foreign_key => object),
                metadata,
                type)
            end

          end

        end
      end
    end
  end
end
