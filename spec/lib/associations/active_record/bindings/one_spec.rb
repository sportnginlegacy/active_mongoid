require "spec_helper"

describe ActiveMongoid::Associations::RecordRelation::Bindings::One do

  let(:player) do
    Player.new
  end

  let(:person) do
    Person.new
  end

  let(:player_metadata) do
    Player.am_relations["person"]
  end

  describe "#bind_one" do

    context "when the child of a references one" do

      let(:binder) do
        described_class.new(player, person, player_metadata)
      end

      context "when the document is bindable with default" do

        before do
          binder.bind_one
        end

        it "sets the inverse relation" do
          expect(person.player).to eq(player)
        end

      end

    end
  end
end
