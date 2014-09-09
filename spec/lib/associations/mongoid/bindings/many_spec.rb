require "spec_helper"

describe ActiveMongoid::Associations::ActiveRecord::Bindings::Many do

  let(:team) do
    Team.new
  end

  let(:player) do
    Player.new
  end

  let(:team_metadata) do
    Team.am_relations["players"]
  end

  describe "#bind_one" do

    context "when the child of a references many" do

      let(:binder) do
        described_class.new(team, player, team_metadata)
      end

      context "when the document is bindable with default" do

        before do
          binder.bind_one(player)
        end

        it "sets the inverse relation" do
          expect(player.team).to eq(team)
        end

      end

    end
  end
end
