require 'spec_helper'

describe ActiveMongoid::Associations::DocumentRelation::Accessors do

  describe "#\{name}=" do

    context "when the relation is a has_one" do

      let(:league) do
        League.create
      end

      context "when the relation does not exist" do

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

      context "when the relation does not exist and class_name is specified" do

        let!(:division_setting) do
          league.build_division_setting
        end

        it "builds the record" do
          expect(league).to have_division_setting
          expect(league.division_setting).to eq(division_setting)
        end


        it "does not save the record" do
          expect(division_setting).to_not be_persisted
        end

      end

      context "when the relation already does exist" do

        let!(:original_division) do
          league.create_division
        end

        let(:new_division) do
          Division.new
        end

        before do
          league.division = new_division
        end

        it "substitutes new record" do
          expect(league.division).to eq(new_division)
        end

        it "removes old relation" do
          expect(original_division.league_id).to be_nil
          expect(original_division).to be_persisted
        end

      end

      context "when foreign_key is defined" do

        let(:post) do
          Post.new
        end

        let!(:division) do
          post.build_division
        end

        it "build the document" do
          expect(post).to have_division
        end

        it "binds the reverse" do
          expect(division).to have_post
        end

      end


    end

    context "when the relation is a belongs_to" do

      let(:person) do
        Person.create
      end

      context "when the relation does not exist" do

        let!(:player) do
          person.build_player
        end

        it "builds the record" do
          expect(person).to have_player
          expect(person.player).to eq(player)
        end

      end

      context "when the relation already does exist" do

        let!(:original_player) do
          person.create_player
        end

        let(:new_player) do
          Player.new
        end

        before do
          person.player = new_player
        end

        it "substitutes new record" do
          expect(person.player).to eq(new_player)
        end

        it "removes old relation" do
          expect(person.player_id).to be_nil
        end

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
