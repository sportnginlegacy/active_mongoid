require "spec_helper"

describe ActiveMongoid::Associations::DocumentRelation::Bindings::In do

  let(:person) do
    Person.new
  end

  let(:player) do
    Player.new
  end

  let(:person_metadata) do
    Person.am_relations["player"]
  end

  describe "#bind_one" do

    context "when the child of a references one" do

      let(:binder) do
        described_class.new(person, player, person_metadata)
      end

      context "when the document is bindable with default" do

        before do
          binder.bind_one
        end

        it "sets the inverse relation" do
          expect(player.person).to eq(person)
        end

      end

    end
  end
end
