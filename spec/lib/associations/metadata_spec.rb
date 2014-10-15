require "spec_helper"

describe ActiveMongoid::Associations::Metadata do

  let(:has_one_document_relation) { ActiveMongoid::Associations::DocumentRelation::Referenced::One }
  let(:has_many_documents_relation) { ActiveMongoid::Associations::DocumentRelation::Referenced::Many }
  let(:belongs_to_document_relation) { ActiveMongoid::Associations::DocumentRelation::Referenced::In }
  let(:has_one_record_relation) { ActiveMongoid::Associations::RecordRelation::Referenced::One }
  let(:has_many_records_relation) { ActiveMongoid::Associations::RecordRelation::Referenced::Many }
  let(:belong_to_record_relation) { ActiveMongoid::Associations::RecordRelation::Referenced::In }

  describe "#builder" do

    let(:metadata) do
      described_class.new(relation: has_one_document_relation)
    end

    let(:object) do
      double
    end

    let(:base) do
      double
    end

    it "returns the builder from the relation" do
      expect(
        metadata.builder(base, object)
      ).to be_a_kind_of(ActiveMongoid::Associations::Builders::One)
    end
  end

  describe "#class_name" do
    context "when class_name provided" do
      context "when the class name contains leading ::" do
        let(:metadata) do
          described_class.new(
            relation: has_one_document_relation,
            class_name: "::Person"
          )
        end

        it "returns the stripped class name" do
          expect(metadata.class_name).to eq("Person")
        end
      end

      context "when the class name has no prefix" do
        let(:metadata) do
          described_class.new(
            relation: Mongoid::Relations::Referenced::Many,
            class_name: "Person"
          )
        end

        it "constantizes the class name" do
          expect(metadata.class_name).to eq("Person")
        end
      end
    end

    context "when no class_name provided" do
      context "when inverse_class_name is provided" do
        context "when inverse_class_name is a simple class name" do
          context "when association name is singular" do
            let(:relation) do
              has_one_document_relation
            end

            let(:metadata) do
              described_class.new(name: :name, relation: relation, inverse_class_name: "Person")
            end

            it "classifies and constantizes the association name and adds the module" do
              expect(metadata.class_name).to eq("Name")
            end
          end

          context "when association name is plural" do
            let(:relation) do
              has_many_documents_relation
            end

            let(:metadata) do
              described_class.new(name: :addresses, relation: relation, inverse_class_name: "Person")
            end

            it "classifies and constantizes the association name and adds the module" do
              expect(metadata.class_name).to eq("Address")
            end
          end
        end
      end

      context "when no inverse_class_name is provided" do
        context "when association name is singular" do

          let(:relation) do
            has_one_document_relation
          end

          let(:metadata) do
            described_class.new(name: :name, relation: relation)
          end

          it "classifies and constantizes the association name" do
            expect(metadata.class_name).to eq("Name")
          end
        end

        context "when association name is plural" do

          let(:relation) do
            has_many_documents_relation
          end

          let(:metadata) do
            described_class.new(name: :addresses, relation: relation)
          end

          it "classifies and constantizes the association name" do
            expect(metadata.class_name).to eq("Address")
          end
        end
      end
    end
  end

  describe "#destructive?" do
    context "when the relation has a destructive dependent option" do
      let(:metadata) do
        described_class.new(
          relation: has_many_documents_relation,
          dependent: :destroy
        )
      end

      it "returns true" do
        expect(metadata).to be_destructive
      end
    end

    context "when no dependent option" do
      let(:metadata) do
        described_class.new(
          relation: has_many_documents_relation
        )
      end

      it "returns false" do
        expect(metadata).to_not be_destructive
      end
    end
  end


end
