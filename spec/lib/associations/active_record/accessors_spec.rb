require 'spec_helper'

describe ActiveMongoid::Associations::ActiveRecord::Accessors do

  describe "#\{name}=" do

    context "when the relation is a has one" do

      let(:player) do
        Player.new
      end

      let!(:person) do
        player.build_person
      end

      it "builds the document" do
        expect(player).to have_person
      end


      it "does not save the document" do
        expect(person).to_not be_persisted
      end
    end

  end

  describe "#\{name}" do
    let(:player) do
      Player.create
    end

    context "when the relation is a has one" do

      context "when relation exists" do

        before do
          Person.create(player_id: player.id)
        end

        it "finds the document" do
          expect(player).to have_person
        end

      end

      context "when relation does not exist" do

        it "does not find the document" do
          expect(player).to_not have_person
        end

      end

    end
  end

end
