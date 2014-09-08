require "spec_helper"

describe ActiveMongoid::Associations::ActiveRecord::Referenced::One do

  describe ".criteria" do


    context "" do

      let(:id) do
        1
      end

      let(:metadata) do
        Player.am_relations["person"]
      end

      let(:criteria) do
        described_class.criteria(metadata, id, Person)
      end

      it "does not include the type in the criteria" do
        expect(criteria.selector).to eq({"player_id" => id})
        expect(criteria.klass).to eq(Person)
      end
    end
  end
end
