require "spec_helper"

describe ActiveMongoid::Associations::Mongoid::Dependent do

  describe ".dependent_records" do

    context "relation is a has_one" do

      let(:base_class) { League }
      let(:target_class) { Division }
      let(:relation_name) { :division }
      let(:persisted_base) { base_class.create }
      let(:new_target) { target_class.new }
      let(:metadata) { base_class.am_relations[relation_name.to_s] }

      before do
        base_class.dependent_records(metadata.merge!(dependent: :destroy))
        persisted_base.division = new_target
        new_target.save!
      end

      it "destroys dependent" do
        persisted_base.destroy
        expect { new_target.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

    context "relation is a belongs_to" do

      let(:base_class) { Person }
      let(:target_class) { Player }
      let(:relation_name) { :player }
      let(:new_base) { base_class.new }
      let(:persisted_target) { target_class.create }
      let(:metadata) { base_class.am_relations[relation_name.to_s] }

      before do
        base_class.dependent_records(metadata.merge!(dependent: :destroy))
        new_base.player = persisted_target
        new_base.save!
      end

      it "destroys dependent" do
        new_base.destroy
        expect { persisted_target.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

    context "relation is a has_many" do

      let(:base_class) { Team }
      let(:target_class) { Player }
      let(:relation_name) { :players }
      let(:persisted_base) { base_class.create }
      let(:new_target) { target_class.new }
      let(:metadata) { base_class.am_relations[relation_name.to_s] }

      before do
        base_class.dependent_records(metadata.merge!(dependent: :destroy))
        persisted_base.players << new_target
        new_target.save!
      end

      it "destroys dependents" do
        persisted_base.destroy
        expect { new_target.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

end
