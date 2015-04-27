require "spec_helper"

describe ActiveMongoid::Associations::RecordRelation::Macros do

  class MongoidTestClass
    include Mongoid::Document
    include ActiveMongoid::Associations
  end

  let(:klass) { MongoidTestClass }

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

      let(:object) { klass.new }

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
          ActiveMongoid::Associations::RecordRelation::Referenced::In
        )
      end

      it "creates the field for the foreign key" do
        expect(object).to respond_to(:person_id)
      end

      context "metadata properties" do

        let(:metadata) { klass.am_relations["person"] }

        it "automatically adds the name" do
          expect(metadata.name).to eq("person")
        end

        it "automatically adds the inverse class name" do
          expect(metadata.inverse_class_name).to eq("MongoidTestClass")
        end
      end
    end
  end

  describe "has_one_record" do

    it "defines the macro" do
      expect(klass).to respond_to(:has_one_record)
    end

    context "when defining the relation" do

      before do
        klass.has_one_record :person
      end

      let(:object) { klass.new }

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
          ActiveMongoid::Associations::RecordRelation::Referenced::One
        )
      end
    end
  end

  describe "has_many_records" do

    it "defines the macro" do
      expect(klass).to respond_to(:has_many_records)
    end

    context "when defining the relation" do

      before do
        klass.has_many_records :persons
      end

      let(:object) { klass.new }

      it "adds the metadata to the klass" do
        expect(klass.am_relations['persons']).to_not be_nil
      end

      it "defines the getter" do
        expect(object).to respond_to(:persons)
      end

      it "defines the setter" do
        expect(object).to respond_to(:persons=)
      end

      it "creates the correct relation" do
        expect(klass.am_relations["persons"].relation).to eq(
          ActiveMongoid::Associations::RecordRelation::Referenced::Many
        )
      end
    end
  end

  describe "has_and_belongs_to_many_records" do

    it "defines the macro" do
      expect(klass).to respond_to(:has_and_belongs_to_many_records)
    end

    context "when defining the relation" do

      before do
        klass.has_and_belongs_to_many_records :persons
      end

      let(:object) { klass.new }

      it "adds the metadata to the klass" do
        expect(klass.am_relations['persons']).to_not be_nil
      end

      it "defines the getter" do
        expect(object).to respond_to(:persons)
      end

      it "defines the setter" do
        expect(object).to respond_to(:persons=)
      end

      it "defines the ids getter" do
        expect(object).to respond_to(:person_ids)
      end

      it "defines the ids setter" do
        expect(object).to respond_to(:person_ids=)
      end

      it "creates the correct relation" do
        expect(klass.am_relations["persons"].relation).to eq(
          ActiveMongoid::Associations::RecordRelation::Referenced::ManyToMany
        )
      end
    end
  end

end
