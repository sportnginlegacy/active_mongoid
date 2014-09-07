require "spec_helper"

describe ActiveMongoid::Associations::Mongoid::AutoSave do

  describe ".autosave_documents" do

    describe "when relation is has_one" do

      before(:all) do
        League.autosave_records(League.am_relations["division"].merge!(autosave: true))
      end

      after(:all) do
        League.reset_callbacks(:save)
      end

      let(:league) do
        League.new
      end

      context "when the option is provided" do

        let(:division) do
          Division.new(name: "Foo")
        end

        before do
          league.division = division
        end

        context "when saving the parent document" do

          before do
            league.save
          end

          it "does save self" do
            expect(league).to be_persisted
          end

          it "does save the relation" do
            expect(division).to be_persisted
          end

          it "does save the relation id" do
            expect(league.id).to_not be_nil
            expect(division.league_id).to eq(league.id)
          end

        end

      end

    end

    describe "when relation is a belongs_to" do

      before(:all) do
        Person.autosave_records(Person.am_relations["player"].merge!(autosave: true))
      end

      after(:all) do
        Person.reset_callbacks(:save)
      end

      let(:person) do
        Person.new
      end

      context "when the option is provided" do

        let(:player) do
          Player.new(name: "Foo")
        end

        before do
          person.player = player
        end

        context "when saving the parent document" do

          before do
            person.save
          end

          it "does save self" do
            expect(person).to be_persisted
          end

          it "does save the relation" do
            expect(player).to be_persisted
          end

          xit "does save the relation id" do
            expect(player.id).to_not be_nil
            expect(person.player_id).to eq(player.id)
          end

        end

      end

    end

  end

end

