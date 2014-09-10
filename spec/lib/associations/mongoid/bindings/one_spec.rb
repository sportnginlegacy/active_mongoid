require "spec_helper"

describe ActiveMongoid::Associations::Mongoid::Bindings::One do

  let(:league){ League.new }

  let(:division){ Division.new }

  let(:division_setting){ Settings::DivisionSetting.new }

  let(:league_metadata){ League.am_relations["division"] }

  describe "#bind_one" do

    context "when the child of a references belongs_to" do

      let(:binder) do
        described_class.new(league, division, league_metadata)
      end

      context "when the document is bindable with default" do

        before do
          binder.bind_one
        end

        it "sets the inverse relation" do
          expect(division.league).to eq(league)
        end

      end

    end

    context "when the child of a references belongs_to with class_name" do

      let(:binder) do
        described_class.new(league, division_setting, league_metadata)
      end

      context "when the document is bindable with default" do

        before do
          binder.bind_one
        end

        it "sets the inverse relation" do
          expect(division_setting.league).to eq(league)
        end

      end

    end

  end

end
