module ActiveMongoid
  module Associations
    module Mongoid
      module Accessors
        extend ActiveSupport::Concern

        def build_record(name, object, metadata)
          relation = create_record_relation(object, metadata)
          set_record_relation(name, relation)
        end

        def set_record_relation(name, object)
          instance_variable_set("@#{name}", object)
        end

        def create_record_relation(object, metadata)
          target = metadata.builder(self, object).build(nil)
          target ? metadata.relation.new(self, target, metadata) : nil
        end


        private

        def get_record_relation(name, metadata, object, reload = false)
          if !reload && (value = instance_variable_get("@#{name}")) != nil
            value
          else
            if object && needs_no_database_query?(object, metadata)
              build_record(name, object, metadata)
            else
              build_record(name, attributes[metadata.key], metadata)
            end
          end
        end

        def needs_no_database_query?(object, metadata)
          object.is_a?(::ActiveRecord::Base) && object.id == attributes[metadata.key]
        end


        module ClassMethods

          private

          def existence_check(name)
            module_eval <<-END
              def #{name}?
                !__send__(:#{name}).blank?
              end
              alias :has_#{name}? :#{name}?
            END
            self
          end

          def record_getter(name, metadata)
            self.instance_eval do
              define_method(name) do |reload = false|
                get_record_relation(name, metadata, nil, reload)
              end
            end
          end

          def record_setter(name, metadata)
            self.instance_eval do
              define_method("#{name}=") do |object|
                if value = get_record_relation(name, metadata, object)
                  set_record_relation(name, value.substitute_record(object))
                else
                  build_record(name, object, metadata)
                end
              end
            end
          end

        end
      end
    end
  end
end
