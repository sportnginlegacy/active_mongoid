module ActiveMongoid
  module Associations
    module Mongoid
      module Builders
        extend ActiveSupport::Concern

        module ClassMethods
          def record_builder(name, metadata)
            define_method("build_#{name}") do |attributes = {}|
              record = metadata.klass.new(attributes)
              send("#{name}=", record)
            end
            self
          end

          def record_creator(name, metadata)
            define_method("create_#{name}") do |attributes = {}|
              record = metadata.klass.new(attributes)
              obj = send("#{name}=", record)
              record.save
              save if metadata.stores_foreign_key?
              obj
            end
            self
          end
        end

      end
    end
  end
end
