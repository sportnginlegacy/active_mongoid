require 'spec_helper'

describe ActiveMongoid::Associations::RecordRelation::Accessors do

  describe "#\{name}=" do

    context "when the relation is a has_one" do
      let(:league) { League.create }

      context "when the relation does not exist" do
        let!(:division) { league.build_division }

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
        let!(:original_division) { league.create_division }
        let(:new_division) { Division.new }

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
        let(:post) { Post.new }
        let!(:division) { post.build_division }

        it "build the document" do
          expect(post).to have_division
        end

        it "binds the reverse" do
          expect(division).to have_post
        end
      end

      context "when the relation is polymorphic" do
        let(:address) { Address.new }
        before do
          league.address = address
        end

        it "builds the document" do
          expect(league).to have_address
        end

        it "binds the reverse" do
          expect(address).to have_target
          expect(address.target).to eq(league)
        end
      end
    end

    context "when the relation is a belongs_to" do
      context "when inverse is a has_one_document" do
        let(:person) { Person.create }

        context "when the relation does not exist" do
          let!(:player) { person.build_player }

          it "builds the record" do
            expect(person).to have_player
            expect(person.player).to eq(player)
          end
        end

        context "when the relation already does exist" do
          let!(:original_player) { person.create_player }
          let(:new_player) { Player.new }

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

        context "when the relation is polymorphic" do
          let(:stat) { Stat.create }
          let(:player) { Player.create }

          before do
            stat.target = player
          end

          it "builds the record" do
            expect(stat).to have_target
          end

          it "sets the attributes" do
            expect(stat.target_id).to eq(player.id)
            expect(stat.target_type).to eq(player.class.to_s)
          end

          it "reloads the record" do
            expect(stat.target(true)).to eq(player)
          end

          it "binds the inverse" do
            expect(player.stat).to eq(stat)
          end
        end
      end

      context "when inverse is a has_many_documents" do
        let(:team) { Team.create}

        context "when the relation does not exist" do
          let!(:division) { team.build_division }

          it "builds the record" do
            expect(team).to have_division
            expect(team.division).to eq(division)
          end

          it "does not save the record" do
            expect(division).to_not be_persisted
          end

          it "binds the inverse" do
            expect(division.teams).to eq([team])
          end
        end

        context "when the relation already does exist" do
          let!(:original_division) { team.create_division }
          let(:new_division) { Division.new }

          before do
            team.division = new_division
          end

          it "substitutes new record" do
            expect(team.division).to eq(new_division)
          end
        end
      end

    end

    context "when the relation is a has_many_records" do
      let(:team) { Team.create }
      let(:players) { [Player.new] }

      context "when the relation does not exist" do
        before do
          team.players = players
        end

        it "builds the record" do
          expect(team).to have_players
        end
      end

      context "when the relation already exists" do
        let!(:original_players) { [team.players.create] }
        let(:new_players) { [Player.new] }

        before do
          team.players = new_players
        end

        it "removes old relation" do
          original_players.each do |player|
            expect(player.team_id).to be_nil
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
    let(:league) { League.create }

    context "when the relation is a has_one_record" do
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

      context "when relation is polymorphic" do
        let!(:address) { Address.create }

        before do
          league.address = address
        end

        it "finds the record" do
          expect(league.address).to eq(address)
        end
      end
    end

    context "when the relation is a has_many_records" do
      let(:team) { Team.create }

      context "when relation exists" do
        before do
          Player.create(name: 'b', team_id: team.id)
          Player.create(name: 'a', team_id: team.id)
        end

        it "finds the records" do
          expect(team).to have_players
        end

        it "finds the records in order" do
          expect(team.players.first.name).to eq('a')
          expect(team.players.last.name).to eq('b')
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

      context "when relation is polymorphic" do
        let(:player) { Player.create }
        let(:stat) { Stat.create(target_id: player.id, target_type: player.class) }

        it "finds the document" do
          expect(stat.target).to eq(player)
        end
      end
    end

  end

end
