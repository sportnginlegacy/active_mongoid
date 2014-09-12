require "spec_helper"

shared_examples "a has_one dependent relation" do

  context "relation is a has_one" do

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
      expect(target_class.all).not_to include(new_target)
    end

  end

end
