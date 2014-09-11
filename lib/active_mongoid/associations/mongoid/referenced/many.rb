module ActiveMongoid
  module Associations
    module Mongoid
      module Referenced
        class Many < Associations::Many

          private

          def criteria
            Many.criteria(__metadata__, base.send(__metadata__.primary_key), base.class)
          end

          def binding
            Bindings::Many.new(base, target, __metadata__)
          end

          # TODO: look into AR analog to collection insert
          def persist_delayed(objs, inserts)
            unless objs.empty?
              # collection.insert(inserts)
              inserts.each do |insert|
                insert.save
              end
              objs.each do |obj|
                # obj.save
                # obj.post_persist
              end
            end
          end

          def save_or_delay(obj, objs, inserts)
            if obj.new_record? && obj.valid?(:create)
              # obj.run_before_callbacks(:save, :create)
              obj.save
              objs.push(obj)
              inserts.push(obj)
            else
              obj.save
            end
          end

          def remove_all(conditions = nil, method = :delete_all)
            conditions = conditions || {}
            removed = klass.send(method, conditions.merge!(criteria.where_values_hash))
            target.delete_if do |obj|
              if matches?(obj, conditions)
                unbind_one(obj) and true
              end
            end
            removed
          end

          def matches?(obj, conditions)
            conditions.all? {|key, value| obj.attributes[key] == value}
          end

          def remove_not_in(ids)
            removed = criteria.where("id not in (?)", ids)
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
              criteria.scoping do
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
              :has_many_records
            end

            def builder(base, meta, object)
              ActiveMongoid::Associations::Builders::Many.new(base, meta, object || [])
            end

            def criteria(metadata, object, type = nil)
              with_polymorphic_criterion(
                metadata.klass.where(metadata.foreign_key => object.to_s),
                metadata,
                type)
            end

          end
        end
      end
    end
  end
end
