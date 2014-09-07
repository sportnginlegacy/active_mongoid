require 'spec_helper'

describe ActiveMongoid::Associations::ActiveRecord::Accessors do

  describe "#\{name}=" do

    context "when the relation is a has_one" do

      let(:player) do
        Player.create
      end

      context "when the relation does not exist" do

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

      context "when the relation already exists" do

        let!(:original_person) do
          player.create_person
        end

        let(:new_person) do
          Person.new
        end

        before do
          player.person = new_person
        end

        it "substitutes new document" do
          expect(player.person).to eq(new_person)
        end

        it "removes old relation" do
          expect(original_person.player_id).to be_nil
        end

      end

    end

    context "when relation is a belongs_to" do

      let(:division) do
        Division.create
      end

      context "when the relation does not exist" do

        let!(:league) do
          division.build_league
        end

        it "builds the document" do
          expect(division).to have_league
        end

        it "does not save the document" do
          expect(league).to_not be_persisted
        end

      end

      context "when the relation already exists" do

        let!(:original_league) do
          division.create_league
        end

        let(:new_league) do
          League.new
        end

        before do
          division.league = new_league
        end

        it "substitutes new document" do
          expect(division.league).to eq(new_league)
        end

        it "removes old relation" do
          expect(division.league_id).to eq(new_league.id)
        end

      end

    end

  end

  describe "#\{name}" do

    context "when the relation is a has_one" do

      let(:player) do
        Player.create
      end


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

    context "when the relation is a belongs_to" do

      let(:league) do
        League.create
      end

      context "when relation exists" do

        let(:division) do
          Division.new(league_id: league.id)
        end

        it "builds the record" do
          expect(division).to have_league
          expect(division.league).to eq(league)
        end

      end

      context "when relation does not exist" do

        let(:divison) do
          Division.new
        end

        it "does not find record" do
          expect(divison).to_not have_league
        end

      end

    end

  end

end
