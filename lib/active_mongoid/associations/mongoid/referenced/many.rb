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
          # def persist_delayed(docs, inserts)
          #   unless docs.empty?
          #     collection.insert(inserts)
          #     docs.each do |doc|
          #       doc.new_record = false
          #       doc.post_persist
          #     end
          #   end
          # end

          # def save_or_delay(doc, docs, inserts)
          #   if doc.new_record? && doc.valid?(:create)
          #     doc.run_before_callbacks(:save, :create)
          #     docs.push(doc)
          #     inserts.push(doc.as_document)
          #   else
          #     doc.save
          #   end
          # end

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
