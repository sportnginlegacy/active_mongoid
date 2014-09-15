require "spec_helper"

describe ActiveMongoid::Associations::ActiveRecord::Macros do

  ActiveRecord::Schema.define do
  create_table :active_record_test_classes, :force => true do |t|
    t.string :_id
  end
end

  class ActiveRecordTestClass < ActiveRecord::Base
    include ActiveMongoid::Associations
  end

  let(:klass) do
    ActiveRecordTestClass
  end

  before do
    klass.am_relations.clear
  end

  describe "has_one_document" do

    it "defines the macro" do
      expect(klass).to respond_to(:has_one_document)
    end

    context "when defining the relation" do

      before do
        klass.has_one_document :person
      end

      let(:object) do
        klass.new
      end

      it "adds the metadata to the klass" do
        expect(klass.am_relations['person']).to_not be_nil
      end

      it "defines the getter" do
        expect(object).to respond_to(:person)
      end

      it "defines the setter" do
        expect(object).to respond_to(:person=)
      end

      it "defines the builder" do
        expect(object).to respond_to(:build_person)
      end

      it "defines the creator" do
        expect(object).to respond_to(:create_person)
      end

      it "creates the correct relation" do
        expect(klass.am_relations["person"].relation).to eq(
          ActiveMongoid::Associations::ActiveRecord::Referenced::One
        )
      end

    end
  end

end
