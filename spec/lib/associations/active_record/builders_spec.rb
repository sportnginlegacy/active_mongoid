require 'spec_helper'

describe ActiveMongoid::Associations::ActiveRecord::Builders do

  describe "#build_#\{name}" do

    context "when the inverse is a has one" do

      let(:player) do
        Player.new
      end

      let!(:person) do
        player.build_person
      end

      it "builds the document" do
        expect(player.person).to eq(person)
      end

      # it "sets the inverse" do
      #   expect(person.player).to eq(player)
      # end

      # it "does not save the document" do
      #   expect(person).to_not be_persisted
      # end
    end

  end

end
