require "spec_helper"

describe ActiveMongoid::Associations::DocumentRelation::Macros do

  class MongoidTestClass
    include Mongoid::Document
    include ActiveMongoid::Associations
  end

  let(:klass) do
    MongoidTestClass
  end

  before do
    klass.am_relations.clear
  end

  describe ".belongs_to_record" do

    it "defines the macro" do
      expect(klass).to respond_to(:belongs_to_record)
    end

    context "when defining the relation" do

      before do
        klass.belongs_to_record(:person)
      end

      let(:object) do
        klass.new
      end

      it "adds the metadata to the klass" do
        expect(klass.am_relations["person"]).to_not be_nil
      end

      it "defines the getter" do
        expect(object).to respond_to(:person)
      end

      it "defines the setter" do
        expect(object).to respond_to(:person=)
      end

      it "creates the correct relation" do
        expect(klass.am_relations["person"].relation).to eq(
          ActiveMongoid::Associations::DocumentRelation::Referenced::In
        )
      end

      it "creates the field for the foreign key" do
        expect(object).to respond_to(:person_id)
      end

      context "metadata properties" do

        let(:metadata) do
          klass.am_relations["person"]
        end

        it "automatically adds the name" do
          expect(metadata.name).to eq("person")
        end

        it "automatically adds the inverse class name" do
          expect(metadata.inverse_class_name).to eq("MongoidTestClass")
        end
      end
    end
  end

end
