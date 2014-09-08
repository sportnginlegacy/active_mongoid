require "spec_helper"

describe ActiveMongoid::Associations::ActiveRecord::Referenced::Many do

  let(:team_1) do
    Team.new(name: 1)
  end

  let(:team_2) do
    Team.new(name: 2)
  end

  let(:teams) do
    [team_1, team_2]
  end

  describe ".criteria" do

    let(:id) do
      1
    end

    let(:metadata) do
      Division.am_relations["teams"]
    end

    let(:criteria) do
      described_class.criteria(metadata, id, Team)
    end

    it "does not include the type in the criteria" do
      expect(criteria.selector).to eq({"division_id" => id})
      expect(criteria.klass).to eq(Team)
    end

  end

  describe ".<<" do

    context "when base is not persisted" do

      let(:division) do
        Division.new
      end

      let(:team) do
        Team.new
      end

      before do
        division.teams << team
      end

      after do
        division.teams.clear
      end

      context "when target is empty" do

        it "initializes with enumerable target" do
          expect(division.teams.size).to eq(1)
        end

        it "does not persist" do
          division.teams.each do |team|
            expect(team).to_not be_persisted
          end
        end

      end

      context "when target is not empty" do

        let(:new_team) do
          Team.new
        end

        before do
          division.teams << new_team
        end


        it "append with enumerable target" do
          expect(division.teams.size).to eq(2)
        end

        it "does not persist" do
          division.teams.each do |team|
            expect(team).to_not be_persisted
          end
        end

      end

    end

    context "when base is persisted" do

      let(:division) do
        Division.create
      end

      let(:team) do
        Team.new
      end

      before do
        division.teams << team
      end

      after do
        division.teams.clear
      end

      context "when target is empty" do

        it "initializes with enumerable target" do
          expect(division.teams.size).to eq(1)
        end

        it "does persist" do
          division.teams.each do |team|
            expect(team).to be_persisted
          end
        end

        it "binds foreign_key" do
          division.teams.each do |team|
            expect(team.division_id).to eq(division.id)
          end
        end

      end

      context "when target is not empty" do

        let(:new_team) do
          Team.new
        end

        before do
          division.teams << new_team
        end


        it "append with enumerable target" do
          expect(division.teams.size).to eq(2)
        end

        it "does persist" do
          division.teams.each do |team|
            expect(team).to be_persisted
          end
        end

        it "binds foreign_key" do
          division.teams.each do |team|
            expect(team.division_id).to eq(division.id)
          end
        end


      end

    end

  end

  describe ".build" do

    context "when base is not persisted" do

      let(:division) do
        Division.new
      end

      before do
        division.teams.build
      end

      after do
        division.teams.clear
      end

      context "when target is empty" do

        it "initializes with enumerable target" do
          expect(division.teams.size).to eq(1)
        end

        it "does not persist" do
          division.teams.each do |team|
            expect(team).to_not be_persisted
          end
        end

      end

      context "when target is not empty" do

        before do
          division.teams.build
        end

        it "append with enumerable target" do
          expect(division.teams.size).to eq(2)
        end

        it "does not persist" do
          division.teams.each do |team|
            expect(team).to_not be_persisted
          end
        end

      end

    end

    context "when base is persisted" do

      let(:division) do
        Division.create
      end

      before do
        division.teams.build
      end

      after do
        division.teams.clear
      end

      context "when target is empty" do

        it "initializes with enumerable target" do
          expect(division.teams.size).to eq(1)
        end

        it "does not persist" do
          division.teams.each do |team|
            expect(team).to_not be_persisted
          end
        end

        it "binds foreign_key" do
          division.teams.each do |team|
            expect(team.division_id).to eq(division.id)
          end
        end

      end

      context "when target is not empty" do

        before do
          division.teams.build
        end

        it "append with enumerable target" do
          expect(division.teams.size).to eq(2)
        end

        it "does not persist" do
          division.teams.each do |team|
            expect(team).to_not be_persisted
          end
        end

        it "binds foreign_key" do
          division.teams.each do |team|
            expect(team.division_id).to eq(division.id)
          end
        end

      end

    end

  end

  [ :create, :create! ].each do |method|

    describe ".#{method}" do

      context "when base is persisted" do

        let(:division) do
          Division.create
        end

        before do
          division.teams.send(method)
        end

        after do
          division.teams.clear
        end

        context "when target is empty" do

          it "initializes with enumerable target" do
            expect(division.teams.size).to eq(1)
          end

          it "does not persist" do
            division.teams.each do |team|
              expect(team).to be_persisted
            end
          end

        end

        context "when target is not empty" do

          context "when sending single" do

            before do
              division.teams.send(method)
            end

            it "append with enumerable target" do
              expect(division.teams.size).to eq(2)
            end

            it "does not persist" do
              division.teams.each do |team|
                expect(team).to be_persisted
              end
            end

          end

          context "when sending multiple" do

            before do
              division.teams.send(method, [{name: 1}, {name: 2}])
            end

            it "append with enumerable target" do
              expect(division.teams.size).to eq(3)
            end

            it "does not persist" do
              division.teams.each do |team|
                expect(team).to be_persisted
              end
            end
          end

        end

      end

    end

  end

  context ".delete" do

    let(:division) do
      Division.create
    end

    before do
      division.teams << teams
    end

    after do
      division.teams.clear
    end

    it "deletes the specified team" do
      division.teams.delete(team_1)
      expect(division.teams.map(&:id)).to eq([team_2.id])
      expect(team_1.division_id).to be_nil
    end

    it "deletes all teams" do
      expect(Team).to receive(:delete_all).once.with({"division_id" => division.id})
      division.teams.delete_all
    end

    it "destroys all teams" do
      expect(Team).to receive(:destroy_all).once.with({"division_id" => division.id})
      division.teams.destroy_all
    end

  end

  context ".find" do

    let(:division) do
      Division.create
    end

    before do
      division.teams << teams
    end

    it "finds the specified team" do
      team = division.teams.find(team_1.id)
      expect(team).to eq(team_1)
    end

    context "when find_or" do

      context "when initialize_by" do

        let(:new_name) do
          "foo"
        end

        it "returns item when found" do
          team = division.teams.find_or_initialize_by({name: 1})
          expect(team).to eq(team_1)
          expect(team).to be_persisted
        end

        it "initializes item when not found" do
          team = division.teams.find_or_initialize_by({name: new_name})
          expect(team.name).to eq(new_name)
          expect(team).to_not be_persisted
        end

      end

      context "when create_by" do

        let(:new_name) do
          "foo"
        end

        it "returns item when found" do
          team = division.teams.find_or_create_by({name: 1})
          expect(team).to eq(team_1)
          expect(team).to be_persisted
        end

        it "initializes item when not found" do
          team = division.teams.find_or_create_by({name: new_name})
          expect(team.name).to eq(new_name)
          expect(team).to be_persisted
        end

      end

    end

  end

end
