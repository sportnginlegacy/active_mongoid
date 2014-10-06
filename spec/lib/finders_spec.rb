require "spec_helper"

describe ActiveMongoid::Finders do
  let(:klass) { Division.am_scoped }
  let(:division) { Division.create(name: 'foo') }

  describe ".find" do

    describe "when not scoped" do

      it "returns object when request with object fixnum id" do
        expect(klass.find(division.id)).to eq(division)
      end

      it "returns object when request with object bson id" do
        expect(klass.find(division._id)).to eq(division)
      end

      it "raises NotFound exception when request with fixnum id" do
        expect{klass.find(-1)}.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "raises NotFound exception when request with bson id" do
        expect{klass.find(BSON::ObjectId.new)}.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

    describe "when scoped" do

      let(:scoped_klass) { klass.by_name(division.name) }

      it "returns object when request with object fixnum id" do
        expect(scoped_klass.find(division.id)).to eq(division)
      end

      it "returns object when request with object bson id" do
        expect(scoped_klass.find(division._id)).to eq(division)
      end

      it "raises NotFound exception when request with fixnum id" do
        expect{scoped_klass.find(-1)}.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "raises NotFound exception when request with bson id" do
        expect{scoped_klass.find(BSON::ObjectId.new)}.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

  describe ".where" do

    let(:bson_id) { BSON::ObjectId.new }

    before do
      division.update_attributes(sport_id: bson_id)
    end

    describe "when not scoped" do

      it "returns relation by bson_id" do
        expect(klass.where(sport_id: bson_id)).to eq([division])
      end

      it "returns relation by bson_id string" do
        expect(klass.where(sport_id: bson_id.to_s)).to eq([division])
      end

      it "return relation by primary key" do
        expect(klass.where(id: division.id)).to eq([division])
      end

      it "return relation by bson primary key" do
        expect(klass.where(id: division._id)).to eq([division])
      end

    end

    describe "when scoped" do

      let(:scoped_klass) { klass.by_name(division.name) }

      it "returns relation by bson_id" do
        expect(scoped_klass.where(sport_id: bson_id)).to eq([division])
      end

      it "returns relation by bson_id string" do
        expect(scoped_klass.where(sport_id: bson_id.to_s)).to eq([division])
      end

      it "return relation by primary key" do
        expect(scoped_klass.where(id: division.id)).to eq([division])
      end

      it "return relation by bson primary key" do
        expect(scoped_klass.where(id: division._id)).to eq([division])
      end

    end

  end

end
