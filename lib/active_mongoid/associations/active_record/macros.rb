module ActiveMongoid
  module Associations
    module ActiveRecord
      module Macros
        extend ActiveSupport::Concern

        module ClassMethods

          def has_one_document(name, options = {})
            meta = characterize_association(name, Referenced::One, options)
            relate_document(name, meta)
          end

          def belongs_to_document(name, options = {})
            meta = characterize_association(name, Referenced::In, options)
            relate_document(name, meta)
          end

          private

          def relate_document(name, metadata)
            self.am_relations = am_relations.merge(name.to_s => metadata)
            document_builder(name, metadata)
            document_creator(name, metadata)
            document_getter(name, metadata)
            document_setter(name, metadata)
            document_id_setter(name, metadata)
            document_id_getter(name, metadata)
            existence_check(name)
          end

        end

      end

    end
  end
end
