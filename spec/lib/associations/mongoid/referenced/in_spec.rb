require "spec_helper"

describe ActiveMongoid::Associations::DocumentRelation::Referenced::In do

  describe ".criteria" do


    context "" do

      let(:id) do
        1
      end

      let(:metadata) do
        Person.am_relations["player"]
      end

      let(:criteria) do
        described_class.criteria(metadata, id, Player)
      end

      it "does not include the type in the criteria" do
        expect(criteria.where_values_hash).to eq({"id" => id})
      end
    end
  end
end
