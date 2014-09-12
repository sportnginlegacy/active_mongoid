require "spec_helper"

shared_examples "a has_many dependent relation" do

  context "relation is a has_many" do
    let(:persisted_base) { base_class.create }
    let(:new_target) { target_class.new }
    let(:metadata) { base_class.am_relations[relation_name.to_s] }

    before do
      base_class.dependent_records(metadata.merge!(dependent: :destroy))
      persisted_base.players << new_target
      new_target.save!
      persisted_base.save!
    end

    it "destroys dependents" do
      persisted_base.destroy
      expect(target_class.all).not_to include(new_target)
    end

  end

end
