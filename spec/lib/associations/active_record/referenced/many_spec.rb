require "spec_helper"

describe ActiveMongoid::Associations::ActiveRecord::Referenced::Many do

  describe ".criteria" do

    context "" do

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

  end

  describe ".build" do

    context "" do

      let(:division) do
        Division.new
      end

      let(:team) do
        Team.new
      end

      before do
        division.teams << Team.new
      end

      it "initializes with enumerable target" do
        expect(division.teams.size).to eq(1)
      end

    end

  end

end
