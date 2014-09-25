require "spec_helper"

describe ActiveMongoid::Associations::DocumentRelation::Referenced::One do

  describe ".criteria" do


    context "" do

      let(:id) do
        1
      end

      let(:metadata) do
        League.am_relations["division"]
      end

      let(:criteria) do
        described_class.criteria(metadata, id, Division)
      end

      it "does not include the type in the criteria" do
        expect(criteria.where_values_hash).to eq({"league_id" => id})
      end
    end
  end
end
