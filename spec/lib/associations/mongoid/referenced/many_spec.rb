require "spec_helper"

describe ActiveMongoid::Associations::DocumentRelation::Referenced::Many do

  describe ".criteria" do

    let(:id) do
      1
    end

    let(:metadata) do
      Team.am_relations["players"]
    end

    let(:criteria) do
      described_class.criteria(metadata, id, Player)
    end

    it "does not include the type in the criteria" do
      expect(criteria.where_values_hash).to eq({"team_id" => id})
      expect(criteria.klass).to eq(Player)
    end

  end

  it_behaves_like "a has_many relation" do
    let(:base_class) { Team }
    let(:target_class) { Player }
    let(:relation_name) { :players }
  end

end
