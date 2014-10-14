require "spec_helper"


describe ActiveMongoid::Associations::DocumentRelation::Bindings::Many do

  let(:division){ Division.new }

  let(:team){ Team.new }

  let(:division_metadata) do
    Division.am_relations["teams"]
  end

  describe "#bind_one" do

    context "when the child of a references many" do

      let(:binder) do
        described_class.new(division, team, division_metadata)
      end

      context "when the document is bindable with default" do

        before do
          binder.bind_one(team)
        end

        it "sets the inverse relation" do
          expect(team.division).to eq(division)
        end

      end

    end
  end
end
