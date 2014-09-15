require "spec_helper"

describe ActiveMongoid::Associations::ActiveRecord::Dependent do

  describe ".dependent_documents" do

    context "relation is a has_one" do

      let(:base_class) { Player }
      let(:target_class) { Person }
      let(:relation_name) { :person }
      let(:persisted_base) { base_class.create }
      let(:new_target) { target_class.new }
      let(:metadata) { base_class.am_relations[relation_name.to_s] }

      before do
        base_class.dependent_documents(metadata.merge!(dependent: :destroy))
        persisted_base.person = new_target
        new_target.save!
      end

      after do
        base_class.reset_callbacks(:destroy)
      end

      it "destroys dependent" do
        persisted_base.destroy
        expect { new_target.reload }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end

    end

    context "relation is a belongs_to" do

      let(:base_class) { Division }
      let(:target_class) { League }
      let(:relation_name) { :league }
      let(:new_base) { base_class.new }
      let(:persisted_target) { target_class.create }
      let(:metadata) { base_class.am_relations[relation_name.to_s] }

      before do
        base_class.dependent_documents(metadata.merge!(dependent: :destroy))
        new_base.league = persisted_target
        new_base.save!
      end

      after do
        base_class.reset_callbacks(:destroy)
      end

      it "destroys dependent" do
        new_base.destroy
        expect { persisted_target.reload }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end

    end

    context "relation is a has_many" do

      let(:base_class) { Division }
      let(:target_class) { Team }
      let(:relation_name) { :teams }
      let(:persisted_base) { base_class.create }
      let(:new_target) { target_class.new }
      let(:metadata) { base_class.am_relations[relation_name.to_s] }

      before do
        base_class.dependent_documents(metadata.merge!(dependent: :destroy))
        persisted_base.teams << new_target
        new_target.save!
      end

      after do
        base_class.reset_callbacks(:destroy)
      end

      it "destroys dependents" do
        persisted_base.destroy
        expect { new_target.reload }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end

    end

  end

end
