require "spec_helper"

describe ActiveMongoid::BsonId do
  let(:klass) { Division }
  let(:division) { klass.new }

  describe "bson attr getter" do

    it "defines the getter" do
      expect(division).to respond_to(:_id)
    end

    it "initializes with a bson_id when option is present" do
      expect(division._id).to_not be_nil
    end

    it "does not initializes with a bson_id when option is not present" do
      expect(division.sport_id).to be_nil
    end

    it "returns valid bson_id" do
      expect(BSON::ObjectId.legal?(division._id))
    end

  end

  describe "bson attr setter" do

    let(:bson_id) { BSON::ObjectId.new }

    before do
      division.sport_id = bson_id
    end

    it "defines the setter" do
      expect(division).to respond_to(:_id=)
    end

    it "sets attr from bson object" do
      expect(division.sport_id).to eq(bson_id)
    end

    it "sets attr as string" do
      expect(division.read_attribute(:sport_id)).to eq(bson_id.to_s)
    end

  end
end
