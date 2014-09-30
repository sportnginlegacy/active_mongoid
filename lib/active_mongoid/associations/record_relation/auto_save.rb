module ActiveMongoid
  module Associations
    module RecordRelation
      module AutoSave
        extend ActiveSupport::Concern

        def changed_for_autosave?(obj)
          obj.new_record? || obj.changed? || obj.marked_for_destruction?
        end

        module ClassMethods

          def autosave_records(metadata)
            if metadata.autosave?
              save_method = :"autosave_records_for_#{metadata.name}"
              define_method(save_method) do
                if relation = instance_variable_get("@#{metadata.name}")
                  Array(relation).each { |d| d.save if changed_for_autosave?(d) }
                end
              end
              after_save save_method
            end
            autosave_record_id(metadata)
          end

          def autosave_record_id(metadata)
            if metadata.stores_foreign_key?
              save_method = :"autosave_record_id_for_#{metadata.name}"
              define_method(save_method) do
                if relation = instance_variable_get("@#{metadata.name}")
                  self.send(metadata.foreign_key_setter, relation.send(metadata.primary_key))
                end
              end
              before_save save_method
            end
          end


        end
      end
    end
  end
end
