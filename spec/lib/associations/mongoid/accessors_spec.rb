require 'spec_helper'

describe ActiveMongoid::Associations::Mongoid::Accessors do

  describe "#\{name}=" do

    context "when the relation is a has_one" do

      let(:league) do
        League.new
      end

      let!(:division) do
        league.build_division
      end

      it "builds the record" do
        expect(league).to have_division
        expect(league.division).to eq(division)
      end


      it "does not save the record" do
        expect(division).to_not be_persisted
      end
    end

    context "when the relation is a belongs_to" do

      let(:person) do
        Person.new
      end

      let!(:player) do
        person.build_player
      end

      it "builds the record" do
        expect(person).to have_player
        expect(person.player).to eq(player)
      end

    end

  end

  describe "#\{name}" do

    let(:league) do
      League.create
    end

    context "when the relation is a has_one" do

      context "when relation exists" do

        before do
          Division.create(league_id: league.id)
        end

        it "finds the record" do
          expect(league).to have_division
        end

      end

      context "when relation does not exist" do

        it "does not find the record" do
          expect(league).to_not have_division
        end

      end

    end

    context "when the relation is a belongs_to" do

      let(:player) do
        Player.create
      end

      context "when relation exists" do

        let(:person) do
          Person.new(player_id: player.id)
        end

        it "builds the record" do
          expect(person).to have_player
          expect(person.player).to eq(player)
        end

      end

      context "when relation does not exist" do

        let(:person) do
          Person.new
        end

        it "does not find record" do
          expect(person).to_not have_player
        end

      end

    end

  end

end
