require 'spec_helper'

describe ActiveMongoid::Associations::Mongoid::Builders do

  describe "#build_#\{name}" do

    context "when the relation is a has_one" do

      let(:league) do
        League.new
      end

      let!(:division) do
        league.build_division
      end

      it "builds the document" do
        expect(league.division).to eq(division)
      end

      xit "sets the inverse" do
        expect(division.league).to eq(league)
      end

      it "does not save the document" do
        expect(division).to_not be_persisted
      end

    end

    context "when the relation is a belongs to" do

      context "when the inverse is a has one" do

        let(:person) do
          Person.new
        end

        let!(:player) do
          person.build_player
        end

        it "builds the record" do
          expect(person.player).to eq(player)
        end

        xit "sets the inverse" do
          expect(player.person).to eq(person)
        end

        it "does not save the document" do
          expect(person).to_not be_persisted
        end
      end
    end


  end

end
