module ActiveMongoid
  module Associations
    module DocumentRelation
      module Accessors
        extend ActiveSupport::Concern

        def build_document(name, object, metadata)
          relation = create_document_relation(object, metadata)
          set_document_relation(name, relation)
        end

        def set_document_relation(name, object)
          instance_variable_set("@#{name}", object)
        end

        def create_document_relation(object, metadata)
          type = self.attributes[metadata.inverse_type]
          target = metadata.builder(self, object).build(type)
          target ? metadata.relation.new(self, target, metadata) : nil
        end

        private

        def get_document_relation(name, metadata, object, reload = false)
          if !reload && (value = instance_variable_get("@#{name}")) != nil
            value
          else
            if object && needs_no_database_query?(object, metadata)
              build_document(name, object, metadata)
            else
              build_document(name, self.send(metadata.key), metadata)
            end
          end
        end

        def needs_no_database_query?(object, metadata)
          object.is_a?(::Mongoid::Document) && object.id.to_s == attributes[metadata.key].to_s
        end


        module ClassMethods

          def existence_check(name)
            module_eval <<-END
              def #{name}?
                !__send__(:#{name}).blank?
              end
              alias :has_#{name}? :#{name}?
            END
            self
          end

          private
          # Getters

          def document_getter(name, metadata)
            self.instance_eval do
              define_method(name) do |reload = false|
                get_document_relation(name, metadata, nil, reload)
              end
            end
          end

          def document_id_getter(name, metadata)
            self.instance_eval do
              define_method("#{name}_id") do
                attribute = read_attribute("#{name}_id")
                attribute.nil? ? nil : ::ActiveMongoid::BSON::ObjectId.from_string(attribute)
              end
            end
          end

          def document_setter(name, metadata)
            self.instance_eval do
              define_method("#{name}=") do |object|
                if value = get_document_relation(name, metadata, object)
                  set_document_relation(name, value.substitute(object))
                else
                  build_document(name, object, metadata)
                end
              end
            end
          end

          def document_id_setter(name, metadata)
            self.instance_eval do
              define_method("#{name}_id=") do |bson_id|
                attribute = bson_id.nil? ? nil : bson_id.to_s
                write_attribute("#{name}_id", attribute)
              end
            end
          end

        end

      end
    end
  end
end
