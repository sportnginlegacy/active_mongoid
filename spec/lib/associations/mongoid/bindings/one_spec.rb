require "spec_helper"

describe ActiveMongoid::Associations::Mongoid::Bindings::One do

  let(:league) do
    League.new
  end

  let(:division) do
    Division.new
  end

  let(:league_metadata) do
    League.am_relations["division"]
  end

  describe "#bind_one" do

    context "when the child of a references belongs_to" do

      let(:binder) do
        described_class.new(league, division, league_metadata)
      end

      context "when the document is bindable with default" do

        before do
          binder.bind_one
        end

        it "sets the inverse relation" do
          expect(division.league).to eq(league)
        end

      end

    end
  end
end
