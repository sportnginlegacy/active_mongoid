require "spec_helper"

describe ActiveMongoid::Finders do

  describe ".find" do

    describe "when primary id is not bson_attr" do
      let(:klass) { Division }
      let(:subject) { klass.create(name: 'foo') }

      describe "when not scoped" do

        it "returns object when request with object fixnum id" do
          expect(klass.find(subject.id)).to eq(subject)
        end

        it "returns object when request with object bson id" do
          expect(klass.find(subject._id)).to eq(subject)
        end

        it "raises NotFound exception when request with fixnum id" do
          expect{klass.find(-1)}.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "raises NotFound exception when request with bson id" do
          expect{klass.find(::ActiveMongoid::BSON::ObjectId.new)}.to raise_error(ActiveRecord::RecordNotFound)
        end

      end

      describe "when scoped" do

        let(:scoped_klass) { klass.by_name(subject.name) }

        it "returns object when request with object fixnum id" do
          expect(scoped_klass.find(subject.id)).to eq(subject)
        end

        it "returns object when request with object bson id" do
          expect(scoped_klass.find(subject._id)).to eq(subject)
        end

        it "raises NotFound exception when request with fixnum id" do
          expect{scoped_klass.find(-1)}.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "raises NotFound exception when request with bson id" do
          expect{scoped_klass.find(::ActiveMongoid::BSON::ObjectId.new)}.to raise_error(ActiveRecord::RecordNotFound)
        end

      end

    end

    describe "when primary id is bson_attr" do
      let(:klass) { Play }
      let(:subject) { klass.create(name: 'foo') }

      describe "when not scoped" do

        it "returns object when request with object fixnum id" do
          expect(klass.find(subject.id)).to eq(subject)
        end

        it "returns object when request with object bson id" do
          expect(klass.find(subject._id)).to eq(subject)
        end

        it "raises NotFound exception when request with fixnum id" do
          expect{klass.find(-1)}.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "raises NotFound exception when request with bson id" do
          expect{klass.find(::ActiveMongoid::BSON::ObjectId.new)}.to raise_error(ActiveRecord::RecordNotFound)
        end

      end

      describe "when scoped" do

        let(:scoped_klass) { klass.by_name(subject.name) }

        it "returns object when request with object fixnum id" do
          expect(scoped_klass.find(subject.id)).to eq(subject)
        end

        it "returns object when request with object bson id" do
          expect(scoped_klass.find(subject._id)).to eq(subject)
        end

        it "raises NotFound exception when request with fixnum id" do
          expect{scoped_klass.find(-1)}.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "raises NotFound exception when request with bson id" do
          expect{scoped_klass.find(::ActiveMongoid::BSON::ObjectId.new)}.to raise_error(ActiveRecord::RecordNotFound)
        end

      end

    end

    end

  describe ".where" do

    describe "when primary_key is not bson_attr" do
      let(:klass) { Division }
      let(:subject) { klass.create(name: 'foo') }
      let(:bson_id) { ::ActiveMongoid::BSON::ObjectId.new }

      before do
        subject.update_attributes(sport_id: bson_id)
      end

      describe "when not scoped" do

        it "returns relation by bson_id" do
          expect(klass.where(sport_id: bson_id)).to eq([subject])
        end

        it "returns relation by bson_id string" do
          expect(klass.where(sport_id: bson_id.to_s)).to eq([subject])
        end

        it "return relation by primary key" do
          expect(klass.where(id: subject.id)).to eq([subject])
        end

        it "return relation by bson primary key" do
          expect(klass.where(id: subject._id)).to eq([subject])
        end

      end

      describe "when scoped" do

        let(:scoped_klass) { klass.by_name(subject.name) }

        it "returns relation by bson_id" do
          expect(scoped_klass.where(sport_id: bson_id)).to eq([subject])
        end

        it "returns relation by bson_id string" do
          expect(scoped_klass.where(sport_id: bson_id.to_s)).to eq([subject])
        end

        it "return relation by primary key" do
          expect(scoped_klass.where(id: subject.id)).to eq([subject])
        end

        it "return relation by bson primary key" do
          expect(scoped_klass.where(id: subject._id)).to eq([subject])
        end

      end

    end

    describe "when primary_key is not bson_attr" do
      let(:klass) { Play }
      let(:subject) { klass.create(name: 'foo') }
      let(:bson_id) { ::ActiveMongoid::BSON::ObjectId.new }

      before do
        subject.update_attributes(sport_id: bson_id)
      end

      describe "when not scoped" do

        it "returns relation by bson_id" do
          expect(klass.where(sport_id: bson_id)).to eq([subject])
        end

        it "returns relation by bson_id string" do
          expect(klass.where(sport_id: bson_id.to_s)).to eq([subject])
        end

        it "return relation by primary key" do
          expect(klass.where(id: subject.id)).to eq([subject])
        end

        it "return relation by bson primary key" do
          expect(klass.where(id: subject._id)).to eq([subject])
        end

      end

      describe "when scoped" do

        let(:scoped_klass) { klass.by_name(subject.name) }

        it "returns relation by bson_id" do
          expect(scoped_klass.where(sport_id: bson_id)).to eq([subject])
        end

        it "returns relation by bson_id string" do
          expect(scoped_klass.where(sport_id: bson_id.to_s)).to eq([subject])
        end

        it "return relation by primary key" do
          expect(scoped_klass.where(id: subject.id)).to eq([subject])
        end

        it "return relation by bson primary key" do
          expect(scoped_klass.where(id: subject._id)).to eq([subject])
        end

      end
    end

  end

end
