require "spec_helper"

describe ActiveMongoid::Associations::RecordRelation::AutoSave do

  describe ".autosave_documents" do

    describe "relation is a has_one" do

      before(:all) do
        Player.autosave_documents(Player.am_relations["person"].merge!(autosave: true))
      end

      after(:all) do
        Player.reset_callbacks(:save)
      end

      let(:player) do
        Player.new
      end

      context "when the option is provided" do

        let(:person) do
          Person.new(name: "Foo")
        end

        before do
          player.person = person
        end

        context "when saving the parent document" do

          before do
            player.save
          end

          it "does save the self" do
            expect(player).to be_persisted
          end

          it "does save the relation" do
            expect(person).to be_persisted
          end

          it "does save the relation id" do
            expect(player.id).to_not be_nil
            expect(person.player_id).to eq(player.id)
          end

        end

      end

    end

    describe "relation is a belongs_to" do

      before(:all) do
        Division.autosave_documents(Division.am_relations["league"].merge!(autosave: true))
      end

      after(:all) do
        Division.reset_callbacks(:save)
      end

      let(:division) do
        Division.new
      end

      context "when the option is provided" do

        let(:league) do
          League.new(name: "Foo")
        end

        before do
          division.league = league
        end

        context "when saving the parent document" do

          before do
            division.save
          end

          it "does save self" do
            expect(division).to be_persisted
          end

          it "does save the relation" do
            expect(league).to be_persisted
          end

          it "does save the relation id" do
            expect(league.id).to_not be_nil
            expect(division.league_id).to eq(league.id)
          end

        end

      end

    end

    describe "relation is a has_many" do

      before(:all) do
        Division.autosave_documents(Division.am_relations["teams"].merge!(autosave: true))
      end

      after(:all) do
        Division.reset_callbacks(:save)
      end

      let(:division) do
        Division.new
      end

      let(:team) do
        Team.new(name: "Foo")
      end

      context "when the option is provided" do

        before do
          division.teams << team
        end

        context "when saving the parent document" do

          before do
            division.save
          end

          it "does save self" do
            expect(division).to be_persisted
          end

          it "does save the relation" do
            expect(team).to be_persisted
          end

          it "does save the relation id" do
            expect(division.id).to_not be_nil
            expect(team.division_id).to eq(division.id)
          end

        end

      end

    end

  end

end

