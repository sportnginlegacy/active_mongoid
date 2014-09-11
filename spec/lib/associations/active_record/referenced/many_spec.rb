require "spec_helper"

describe ActiveMongoid::Associations::ActiveRecord::Referenced::Many do

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

  it_behaves_like "a has_many relation" do
    let(:base_class) { Division }
    let(:target_class) { Team }
    let(:relation_name) { :teams }
  end

end
