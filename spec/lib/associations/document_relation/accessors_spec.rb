require 'spec_helper'

describe ActiveMongoid::Associations::DocumentRelation::Accessors do

  describe "#\{name}=" do

    context "when the relation is a has_one" do
      let(:player) { Player.create }

      context "when the relation does not exist" do
        let!(:person) { player.build_person }

        it "builds the document" do
          expect(player).to have_person
        end


        it "does not save the document" do
          expect(person).to_not be_persisted
        end
      end

      context "when the relation already exists" do
        let!(:original_person) { player.create_person }
        let(:new_person) { Person.new }

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

      context "when foreign_key is defined" do
        let!(:post) { player.build_post }

        it "build the document" do
          expect(player).to have_post
        end

        it "binds the reverse" do
          expect(post).to have_player
        end
      end

      context "when the relation is polymorphic" do
        let(:stat) { Stat.new }
        before do
          player.stat = stat
        end

        it "builds the document" do
          expect(player).to have_stat
        end

        it "binds the reverse" do
          expect(stat).to have_target
          expect(stat.target).to eq(player)
        end
      end

    end

    context "when relation is a belongs_to" do
      context "when inverse is has_one_record" do
        let(:division) { Division.create }

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
          let!(:original_league) { division.create_league }
          let(:new_league) { League.new }

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

        context "when the relation is polymorphic" do
          let(:address) { Address.create }
          let(:league) { League.create }

          before do
            address.target = league
          end

          it "builds the document" do
            expect(address).to have_target
          end

          it "sets the attributes" do
            expect(address.target_id).to eq(league.id)
            expect(address.target_type).to eq(league.class.to_s)
          end

          it "reloads the document" do
            expect(address.target(true)).to eq(league)
          end

          it "binds the inverse" do
            expect(league.address).to eq(address)
          end
        end
      end

      context "when inverse is a has_many_records" do
        let(:player) { Player.create }

        context "when the relation does not exist" do
          let!(:team) { player.build_team }

          it "builds the document" do
            expect(player).to have_team
          end

          it "does not save the document" do
            expect(team).to_not be_persisted
          end

          it "binds the inverse" do
            expect(team.players).to eq([player])
          end

        end

        context "when the relation already exists" do
          let!(:original_team) { player.create_team }
          let(:new_team) { Team.new }

          before do
            player.team = new_team
          end

          it "substitutes new document" do
            expect(player.team).to eq(new_team)
          end

          it "removes old relation" do
            expect(player.team_id).to eq(new_team.id)
          end
        end
      end

    end

    context "when the relation is a has_many_documents" do
      let(:division) { Division.create }
      let(:teams) { [Team.new] }

      context "when the relation does not exist" do

        before do
          division.teams = teams
        end

        it "builds the document" do
          expect(division).to have_teams
        end
      end

      context "when the relation already exists" do
        let!(:original_teams) { [division.teams.create] }
        let(:new_teams) { [Team.new] }

        before do
          division.teams = new_teams
        end

        it "substitutes new document" do
          expect(division.teams).to eq(new_teams)
        end

        it "removes old relation" do
          original_teams.each do |team|
            expect(team.division_id).to be_nil
          end
        end
      end

      context "when the relation is polymorphic" do
        let(:address) { Address.new }
        let(:person) { Person.create }

        before do
          person.addresses = [address]
        end

        it "builds the document" do
          expect(person.addresses).to eq([address])
        end

        it "sets the attributes" do
          expect(address.target_id).to eq(person.id)
          expect(address.target_type).to eq(person.class.to_s)
        end

        it "binds the inverse" do
          expect(address).to have_target
        end
      end

    end

  end

  describe "#\{name}" do
    context "when the relation is a has_one_document" do
      let(:player) { Player.create }

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

      context "when relation is polymorphic" do
        let!(:stat) { Stat.create(target_id: player.id, target_type: player.class) }

        it "finds the document" do
          expect(player.stat).to eq(stat)
        end
      end
    end

    context "when the relation is a belongs_to_document" do
      let(:league) { League.create }

      context "when relation exists" do
        let(:division) { Division.new(league_id: league.id) }

        it "builds the record" do
          expect(division).to have_league
          expect(division.league).to eq(league)
        end
      end

      context "when relation does not exist" do
        let(:divison) { Division.new }

        it "does not find record" do
          expect(divison).to_not have_league
        end
      end

      context "when relation is polymorphic" do
        let(:address) { Address.create(target_id: league.id, target_type: league.class) }

        it "finds the document" do
          expect(address.target).to eq(league)
        end
      end

    end

    context "when the relation is a has_many_documents" do
      let(:division) { Division.create }

      context "when relation exists" do
        before { Team.create(division: division.id) }

        it "finds the document" do
          expect(division).to have_teams
        end
      end

      context "when relation does not exist" do
        it "does not find the document" do
          expect(division).to_not have_teams
        end
      end

      context "when relation is polymorphic" do
        let!(:stat) { Stat.create(target_id: division.id, target_type: division.class) }

        it "finds the document" do
          expect(division.stats).to eq([stat])
        end
      end

    end

  end

end
