require "spec_helper"

shared_examples "a belongs_to dependent relation" do

  context "relation is a belongs_to" do
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
      expect(target_class.all).not_to include(persisted_target)
    end

  end

end
