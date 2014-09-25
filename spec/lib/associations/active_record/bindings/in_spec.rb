require "spec_helper"

describe ActiveMongoid::Associations::RecordRelation::Bindings::In do

  let(:division) do
    Division.new
  end

  let(:league) do
    League.new
  end

  let(:division_metadata) do
    Division.am_relations["league"]
  end

  describe "#bind_one" do

    context "when the child of a references one" do

      let(:binder) do
        described_class.new(division, league, division_metadata)
      end

      context "when the document is bindable with default" do

        before do
          binder.bind_one
        end

        it "sets the inverse relation" do
          expect(league.division).to eq(division)
        end

      end

    end
  end
end
