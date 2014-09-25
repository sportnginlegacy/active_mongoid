module ActiveMongoid
  module Associations
    module RecordRelation
      module AutoSave
        extend ActiveSupport::Concern

        def changed_for_autosave?(obj)
          obj.new_record? || obj.changed? || obj.marked_for_destruction?
        end

        module ClassMethods

          def autosave_documents(metadata)
            if metadata.autosave?
              save_method = :"autosave_documents_for_#{metadata.name}"
              define_method(save_method) do
                if relation = instance_variable_get("@#{metadata.name}")
                  Array(relation).each { |d| d.save if changed_for_autosave?(d) }
                end
              end

              after_save save_method
            end
          end


        end
      end
    end
  end
end
