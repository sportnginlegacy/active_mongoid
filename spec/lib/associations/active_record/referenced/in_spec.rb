require "spec_helper"

describe ActiveMongoid::Associations::ActiveRecord::Referenced::In do
  describe ".criteria" do
    context "" do

      let(:id) do
        1
      end

      let(:metadata) do
        Division.am_relations["league"]
      end

      let(:criteria) do
        described_class.criteria(metadata, id, League)
      end

      it "does not include the type in the criteria" do
        expect(criteria.selector).to eq({"_id" => id})
        expect(criteria.klass).to eq(League)
      end
    end
  end


end
