module ActiveMongoid
  module Associations
    module DocumentRelation
      module Macros
        extend ActiveSupport::Concern

        module ClassMethods

          def belongs_to_document(name, options = {})
            meta = characterize_association(name, Referenced::In, options)
            relate_one_to_one_document(name, meta)
          end

          def has_one_document(name, options = {})
            meta = characterize_association(name, Referenced::One, options)
            relate_one_to_one_document(name, meta)
          end

          def has_many_documents(name, options = {})
            meta = characterize_association(name, Referenced::Many, options)
            relate_document(name, meta)
            # document_ids_setter(name, metadata)
            # document_ids_getter(name, metadata)
          end

          def has_and_belongs_to_many_documents(name, options = {})
            meta = characterize_association(name, Referenced::ManyToMany, options)
            relate_document(name, meta)
          end

          private

          def relate_one_to_one_document(name, metadata)
            relate_document(name, metadata)
            document_builder(name, metadata)
            document_creator(name, metadata)
            document_id_setter(name, metadata)
            document_id_getter(name, metadata)
          end

          def relate_document(name, metadata)
            self.am_relations = am_relations.merge(name.to_s => metadata)
            document_getter(name, metadata)
            document_setter(name, metadata)
            autosave_documents(metadata)
            dependent_documents(metadata)
            existence_check(name)
          end

        end

      end

    end
  end
end
