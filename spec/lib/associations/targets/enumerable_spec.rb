require "spec_helper"

describe ActiveMongoid::Associations::Targets::Enumerable do

  describe "#==" do

    context "when comparing with an enumerable" do

      let(:team) do
        Team.create
      end

      let!(:player) do
        Player.create(team_id: team.id.to_s)
      end

      context "when only a criteria target exists" do

        let(:criteria) do
          Player.where(team_id: team.id.to_s.to_s)
        end

        let!(:enumerable) do
          described_class.new(criteria)
        end

        xit"returns the equality check" do
          expect(enumerable).to eq([ player ])
        end
      end

      context "when only an array target exists" do

        let!(:enumerable) do
          described_class.new([ player ])
        end

        xit"returns the equality check" do
          expect(enumerable._loaded.values).to eq([ player ])
        end
      end

      context "when a criteria and added exist" do

        let(:criteria) do
          Player.where(team_id: team.id.to_s.to_s)
        end

        let(:enumerable) do
          described_class.new(criteria)
        end

        let(:player_two) do
          Player.new
        end

        context "when the added does not contain unloaded docs" do

          before do
            enumerable << player_two
          end

          xit"returns the equality check" do
            expect(enumerable).to eq([ player, player_two ])
          end
        end

        context "when the added contains unloaded docs" do

          before do
            enumerable << player
          end

          xit"returns the equality check" do
            expect(enumerable).to eq([ player ])
          end
        end

        context "when the enumerable is loaded" do

          before do
            enumerable.instance_variable_set(:@executed, true)
          end

          context "when the loaded has no docs and added is persisted" do

            before do
              player.save
              enumerable._added[player.id] = player
            end

            xit"returns the equality check" do
              expect(enumerable).to eq([ player ])
            end
          end
        end
      end
    end

    context "when comparing with a non enumerable" do

      let(:enumerable) do
        described_class.new([])
      end

      xit"returns false" do
        expect(enumerable).to_not eq("team")
      end
    end
  end

  describe "#===" do

    let(:enumerable) do
      described_class.new([])
    end

    context "when compared to an array class" do

      xit"returns true" do
        expect(enumerable === Array).to be true
      end
    end

    context "when compared to a different class" do

      xit"returns false" do
        expect(enumerable === Mongoid::Document).to be false
      end
    end

    context "when compared to an array instance" do

      context "when the entries are equal" do

        let(:other) do
          described_class.new([])
        end

        xit"returns true" do
          expect(enumerable === other).to be true
        end
      end

      context "when the entries are not equal" do

        let(:other) do
          described_class.new([ Team.new ])
        end

        xit"returns false" do
          expect(enumerable === other).to be false
        end
      end
    end
  end

  describe "#<<" do

    let(:team) do
      Team.create
    end

    let!(:player) do
      Player.create(team_id: team.id.to_s.to_s)
    end

    let!(:enumerable) do
      described_class.new([])
    end

    context "when the relation is empty" do

      let!(:added) do
        enumerable << player
      end

      xit"adds the document to the added target" do
        expect(enumerable._added).to eq({ player.id => player })
      end

      xit"returns the added documents" do
        expect(added).to eq([ player ])
      end
    end
  end

  describe "#any?" do

    let(:team) do
      Team.create
    end

    let!(:player_one) do
      Player.create(team_id: team.id.to_s)
    end

    let!(:player_two) do
      Player.create(team_id: team.id.to_s)
    end

    context "when only a criteria target exists" do

      let(:criteria) do
        Player.where(team_id: team.id.to_s.to_s)
      end

      let!(:enumerable) do
        described_class.new(criteria)
      end

      let!(:any) do
        enumerable.any?
      end

      xit"returns true" do
        expect(any).to be true
      end

      xit"retains the correct length" do
        expect(enumerable.length).to eq(2)
      end

      xit"retains the correct length when calling to_a" do
        expect(enumerable.to_a.length).to eq(2)
      end

      context "when iterating over the relation a second time" do

        before do
          enumerable.each { |player| player }
        end

        xit"retains the correct length" do
          expect(enumerable.length).to eq(2)
        end

        xit"retains the correct length when calling to_a" do
          expect(enumerable.to_a.length).to eq(2)
        end
      end
    end
  end

  describe "#clear" do

    let(:team) do
      Team.create
    end

    let!(:player) do
      Player.create(team_id: team.id.to_s)
    end

    let!(:player_two) do
      Player.create(team_id: team.id.to_s)
    end

    let(:criteria) do
      Player.where(team_id: team.id.to_s.to_s)
    end

    let(:enumerable) do
      described_class.new(criteria)
    end

    before do
      enumerable._loaded[player.id] = player
      enumerable << player
    end

    let!(:clear) do
      enumerable.clear do |doc|
        expect(doc).to be_a(Player)
      end
    end

    xit"clears out the loaded docs" do
      expect(enumerable._loaded).to be_empty
    end

    xit"clears out the added docs" do
      expect(enumerable._added).to be_empty
    end

    xit"retains its loaded state" do
      expect(enumerable).to_not be__loaded
    end
  end

  describe "#clone" do

    let(:team) do
      Team.create
    end

    let!(:player) do
      Player.create(title: "one", team_id: team.id.to_s)
    end

    let!(:player_two) do
      Player.create(title: "two", team_id: team.id.to_s)
    end

    let(:criteria) do
      Player.where(team_id: team.id.to_s.to_s)
    end

    let(:enumerable) do
      described_class.new(criteria)
    end

    before do
      enumerable << player
      enumerable << player_two
    end

    let(:cloned) do
      enumerable.clone
    end

    xit"does not retain the first id" do
      expect(cloned.first).to_not eq(player)
    end

    xit"does not retain the last id" do
      expect(cloned.last).to_not eq(player_two)
    end
  end

  describe "#delete" do

    let(:team) do
      Team.create
    end

    context "when the document is loaded" do

      let!(:player) do
        Player.create(team_id: team.id.to_s)
      end

      let!(:enumerable) do
        described_class.new([ player ])
      end

      let!(:deleted) do
        enumerable.delete(player)
      end

      xit"deletes the document from the enumerable" do
        expect(enumerable._loaded).to be_empty
      end

      xit"returns the document" do
        expect(deleted).to eq(player)
      end
    end

    context "when the document is added" do

      let!(:player) do
        Player.new
      end

      let(:criteria) do
        Team.where(team_id: team.id.to_s.to_s)
      end

      let!(:enumerable) do
        described_class.new(criteria)
      end

      before do
        enumerable << player
      end

      let!(:deleted) do
        enumerable.delete(player)
      end

      xit"removes the document from the added docs" do
        expect(enumerable._added).to be_empty
      end

      xit"returns the document" do
        expect(deleted).to eq(player)
      end
    end

    context "when the document is unloaded" do

      let!(:player) do
        Player.create(team_id: team.id.to_s)
      end

      let(:criteria) do
        Player.where(team_id: team.id.to_s)
      end

      let!(:enumerable) do
        described_class.new(criteria)
      end

      let!(:deleted) do
        enumerable.delete(player)
      end

      xit"does not load the document" do
        expect(enumerable._loaded).to be_empty
      end

      xit"returns the document" do
        expect(deleted).to eq(player)
      end
    end

    context "when the document is not found" do

      let!(:player) do
        Player.create(team_id: team.id.to_s)
      end

      let(:criteria) do
        Team.where(team_id: team.id.to_s)
      end

      let!(:enumerable) do
        described_class.new([ player ])
      end

      let!(:deleted) do
        enumerable.delete(Player.new) do |doc|
          expect(doc).to be_nil
        end
      end

      xit"returns nil" do
        expect(deleted).to be_nil
      end
    end
  end

  describe "#delete_if" do

    let(:team) do
      Team.create
    end

    context "when the document is loaded" do

      let!(:player) do
        Player.create(team_id: team.id.to_s)
      end

      let!(:enumerable) do
        described_class.new([ player ])
      end

      let!(:deleted) do
        enumerable.delete_if { |doc| doc == player }
      end

      xit"deletes the document from the enumerable" do
        expect(enumerable._loaded).to be_empty
      end

      xit"returns the remaining docs" do
        expect(deleted).to be_empty
      end
    end

    context "when the document is added" do

      let!(:player) do
        Player.new
      end

      let(:criteria) do
        Team.where(team_id: team.id.to_s)
      end

      let!(:enumerable) do
        described_class.new(criteria)
      end

      before do
        enumerable << player
      end

      let!(:deleted) do
        enumerable.delete_if { |doc| doc == player }
      end

      xit"removes the document from the added docs" do
        expect(enumerable._added).to be_empty
      end

      xit"returns the remaining docs" do
        expect(deleted).to be_empty
      end
    end

    context "when the document is unloaded" do

      let!(:player) do
        Player.create(team_id: team.id.to_s)
      end

      let(:criteria) do
        Player.where(team_id: team.id.to_s)
      end

      let!(:enumerable) do
        described_class.new(criteria)
      end

      let!(:deleted) do
        enumerable.delete_if { |doc| doc == player }
      end

      xit"does not load the document" do
        expect(enumerable._loaded).to be_empty
      end

      xit"returns the remaining docs" do
        expect(deleted).to be_empty
      end
    end

    context "when the block doesn't match" do

      let!(:player) do
        Player.create(team_id: team.id.to_s)
      end

      let(:criteria) do
        Team.where(team_id: team.id.to_s)
      end

      let!(:enumerable) do
        described_class.new([ player ])
      end

      let!(:deleted) do
        enumerable.delete_if { |doc| doc == Player.new }
      end

      xit"returns the remaining docs" do
        expect(deleted).to eq([ player ])
      end
    end
  end

  describe "#detect" do

    let(:team) do
      Team.create
    end

    let!(:player) do
      Player.create(team: team, title: "test")
    end

    let(:criteria) do
      Player.where(team_id: team.id.to_s)
    end

    let!(:enumerable) do
      described_class.new(criteria)
    end

    context "when setting a value on the matching document" do

      before do
        enumerable.detect{ |player| player.title = "test" }.rating = 10
      end

      xit"sets the value on the instance" do
        expect(enumerable.detect{ |player| player.title = "test" }.rating).to eq(10)
      end
    end
  end

  describe "#each" do

    let(:team) do
      Team.create
    end

    let!(:player) do
      Player.create(team_id: team.id.to_s)
    end

    context "when only a criteria target exists" do

      let(:criteria) do
        Player.where(team_id: team.id.to_s)
      end

      let!(:enumerable) do
        described_class.new(criteria)
      end

      let!(:iterated) do
        enumerable.each do |doc|
          expect(doc).to be_a(Player)
        end
      end

      xit"loads each document" do
        expect(enumerable._loaded).to eq({ player.id => player })
      end

      xit"becomes loaded" do
        expect(enumerable).to be__loaded
      end
    end

    context "when only an array target exists" do

      let!(:enumerable) do
        described_class.new([ player ])
      end

      let!(:iterated) do
        enumerable.each do |doc|
          expect(doc).to be_a(Player)
        end
      end

      xit"does not alter the loaded docs" do
        expect(enumerable._loaded).to eq({ player.id => player })
      end

      xit"stays loaded" do
        expect(enumerable).to be__loaded
      end
    end

    context "when a criteria and added exist" do

      let(:criteria) do
        Player.where(team_id: team.id.to_s)
      end

      let!(:enumerable) do
        described_class.new(criteria)
      end

      let(:player_two) do
        Player.new
      end

      context "when the added does not contain unloaded docs" do

        before do
          enumerable << player_two
        end

        let!(:iterated) do
          enumerable.each do |doc|
            expect(doc).to be_a(Player)
          end
        end

        xit"adds the unloaded to the loaded docs" do
          expect(enumerable._loaded).to eq({ player.id => player })
        end

        xit"keeps the appended in the added docs" do
          expect(enumerable._added).to eq({ player_two.id => player_two })
        end

        xit"stays loaded" do
          expect(enumerable).to be__loaded
        end
      end

      context "when the added contains unloaded docs" do

        before do
          enumerable << player
        end

        let!(:iterated) do
          enumerable.each do |doc|
            expect(doc).to be_a(Player)
          end
        end

        xit"adds the persisted added doc to the loaded" do
          expect(enumerable._loaded).to eq({ player.id => player })
        end

        xit"stays loaded" do
          expect(enumerable).to be__loaded
        end
      end
    end

    context "when no block is passed" do

      let(:criteria) do
        Player.where(team_id: team.id.to_s)
      end

      let!(:enumerable) do
        described_class.new(criteria)
      end

      xit"returns an enumerator" do
        expect(enumerable.each.class.include?(Enumerable)).to be true
      end

    end
  end

  describe "#entries" do

    let(:team) do
      Team.create
    end

    let(:criteria) do
      Player.where(team_id: team.id.to_s)
    end

    let!(:enumerable) do
      described_class.new(criteria)
    end

    context "when the added contains a persisted document" do

      let!(:player) do
        Player.create(team_id: team.id.to_s)
      end

      before do
        enumerable << player
      end

      let(:entries) do
        enumerable.entries
      end

      xit"yields to the in memory documents first" do
        expect(entries.first).to equal(player)
      end
    end
  end

  describe "#first" do

    let(:team) do
      Team.create
    end

    context "when the enumerable is not loaded" do

      let(:criteria) do
        Player.where(team_id: team.id.to_s)
      end

      let(:enumerable) do
        described_class.new(criteria)
      end

      context "when unloaded is not empty" do

        context "when added is empty" do

          let!(:player) do
            Player.create(team_id: team.id.to_s)
          end

          let(:first) do
            enumerable.first
          end

          xit"returns the first unloaded doc" do
            expect(first).to eq(player)
          end

          xit"does not load the enumerable" do
            expect(enumerable).to_not be__loaded
          end

          xit"receives query only once" do
            expect(criteria).to receive(:first).once
            first
          end
        end

        context "when added is not empty" do

          let!(:player) do
            Player.create(team_id: team.id.to_s)
          end

          let(:player_two) do
            Player.new(team_id: team.id.to_s)
          end

          before do
            enumerable << player_two
          end

          let(:first) do
            enumerable.first
          end

          context "when a perviously persisted unloaded doc exists" do

            xit"returns the first added doc" do
              expect(first).to eq(player)
            end

            xit"does not load the enumerable" do
              expect(enumerable).to_not be__loaded
            end
          end
        end
      end

      context "when unloaded is empty" do

        let!(:player) do
          Player.new(team_id: team.id.to_s)
        end

        before do
          enumerable << player
        end

        let(:first) do
          enumerable.first
        end

        xit"returns the first loaded doc" do
          expect(first).to eq(player)
        end

        xit"does not load the enumerable" do
          expect(enumerable).to_not be__loaded
        end
      end

      context "when unloaded and added are empty" do

        let(:first) do
          enumerable.first
        end

        xit"returns nil" do
          expect(first).to be_nil
        end

        xit"does not load the enumerable" do
          expect(enumerable).to_not be__loaded
        end
      end
    end

    context "when the enumerable is loaded" do

      context "when loaded is not empty" do

        let!(:player) do
          Player.create(team_id: team.id.to_s)
        end

        let(:enumerable) do
          described_class.new([ player ])
        end

        let(:first) do
          enumerable.first
        end

        xit"returns the first loaded doc" do
          expect(first).to eq(player)
        end
      end

      context "when loaded is empty" do

        let!(:player) do
          Player.create(team_id: team.id.to_s)
        end

        let(:enumerable) do
          described_class.new([])
        end

        before do
          enumerable << player
        end

        let(:first) do
          enumerable.first
        end

        xit"returns the first added doc" do
          expect(first).to eq(player)
        end
      end

      context "when loaded and added are empty" do

        let(:enumerable) do
          described_class.new([])
        end

        let(:first) do
          enumerable.first
        end

        xit"returns nil" do
          expect(first).to be_nil
        end
      end
    end
  end

  describe "#include?" do

    let(:team) do
      Team.create
    end

    let!(:player_one) do
      Player.create(team_id: team.id.to_s)
    end

    let!(:player_two) do
      Player.create(team_id: team.id.to_s)
    end

    context "when no criteria exists" do

      context "when the enumerable is loaded" do

        let!(:enumerable) do
          described_class.new([ player_one, player_two ])
        end

        let!(:included) do
          enumerable.include?(player_two)
        end

        xit"returns true" do
          expect(included).to be true
        end

        xit"retains the correct length" do
          expect(enumerable.length).to eq(2)
        end

        xit"retains the correct length when calling to_a" do
          expect(enumerable.to_a.length).to eq(2)
        end
      end

      context "when the enumerable contains an added document" do

        let!(:enumerable) do
          described_class.new([])
        end

        let(:player_three) do
          Player.new(team_id: team)
        end

        before do
          enumerable.push(player_three)
        end

        let!(:included) do
          enumerable.include?(player_three)
        end

        xit"returns true" do
          expect(included).to be true
        end
      end
    end

    context "when the document is present and not the first" do

      let(:criteria) do
        Player.where(team_id: team.id.to_s)
      end

      let!(:enumerable) do
        described_class.new(criteria)
      end

      let!(:included) do
        enumerable.include?(player_two)
      end

      xit"returns true" do
        expect(included).to be true
      end

      xit"retains the correct length" do
        expect(enumerable.length).to eq(2)
      end

      xit"retains the correct length when calling to_a" do
        expect(enumerable.to_a.length).to eq(2)
      end

      context "when iterating over the relation a second time" do

        before do
          enumerable.each { |player| player }
        end

        xit"retains the correct length" do
          expect(enumerable.length).to eq(2)
        end

        xit"retains the correct length when calling to_a" do
          expect(enumerable.to_a.length).to eq(2)
        end
      end
    end
  end

  describe "#initialize" do

    let(:team) do
      Team.new
    end

    context "when provided with a criteria" do

      let(:criteria) do
        Player.where(team_id: team.id.to_s)
      end

      let(:enumerable) do
        described_class.new(criteria)
      end

      xit"sets the criteria" do
        expect(enumerable._unloaded).to eq(criteria)
      end

      xit"is not loaded" do
        expect(enumerable).to_not be__loaded
      end
    end

    context "when provided an array" do

      let(:player) do
        Player.new
      end

      let(:enumerable) do
        described_class.new([ player ])
      end

      xit"does not set a criteria" do
        expect(enumerable._unloaded).to be_nil
      end

      xit"is loaded" do
        expect(enumerable).to be__loaded
      end
    end
  end

  describe "#in_memory" do

    let(:team) do
      Team.new
    end

    context "when the enumerable is loaded" do

      let(:player) do
        Player.new
      end

      let(:enumerable) do
        described_class.new([ player ])
      end

      let(:player_two) do
        Player.new
      end

      before do
        enumerable << player_two
      end

      let(:in_memory) do
        enumerable.in_memory
      end

      xit"returns the loaded and added docs" do
        expect(in_memory).to eq([ player, player_two ])
      end
    end

    context "when the enumerable is not loaded" do

      let(:player) do
        Player.new(team_id: team.id.to_s)
      end

      let(:enumerable) do
        described_class.new(Player.where(team_id: team.id.to_s))
      end

      let(:player_two) do
        Player.new(team_id: team.id.to_s)
      end

      before do
        enumerable << player_two
      end

      let(:in_memory) do
        enumerable.in_memory
      end

      xit"returns the added docs" do
        expect(in_memory).to eq([ player_two ])
      end
    end

    context "when passed a block" do

      let(:enumerable) do
        described_class.new(Player.where(team_id: team.id.to_s))
      end

      let(:player_two) do
        Player.new(team_id: team.id.to_s)
      end

      before do
        enumerable << player_two
      end

      xit"yields to each in memory document" do
        enumerable.in_memory do |doc|
          expect(doc).to eq(player_two)
        end
      end
    end
  end

  describe "#is_a?" do

    let(:enumerable) do
      described_class.new(Player.all)
    end

    context "when checking against enumerable" do

      xit"returns true" do
        expect(enumerable.is_a?(::Enumerable)).to be true
      end
    end

    context "when checking against array" do

      xit"returns true" do
        expect(enumerable.is_a?(Array)).to be true
      end
    end
  end

  describe "#last" do

    let(:team) do
      Team.create
    end

    context "when the enumerable is not loaded" do

      let(:criteria) do
        Player.where(team_id: team.id.to_s)
      end

      let(:enumerable) do
        described_class.new(criteria)
      end

      context "when unloaded is not empty" do

        let!(:player) do
          Player.create(team_id: team.id.to_s)
        end

        let(:last) do
          enumerable.last
        end

        xit"returns the last unloaded doc" do
          expect(last).to eq(player)
        end

        xit"does not load the enumerable" do
          expect(enumerable).to_not be__loaded
        end

        xit"receives query only once" do
          expect(criteria).to receive(:last).once
          last
        end
      end

      context "when unloaded is empty" do

        let!(:player) do
          Player.new(team_id: team.id.to_s)
        end

        before do
          enumerable << player
        end

        let(:last) do
          enumerable.last
        end

        xit"returns the last unloaded doc" do
          expect(last).to eq(player)
        end

        xit"does not load the enumerable" do
          expect(enumerable).to_not be__loaded
        end
      end

      context "when unloaded and added are empty" do

        let(:last) do
          enumerable.last
        end

        xit"returns nil" do
          expect(last).to be_nil
        end

        xit"does not load the enumerable" do
          expect(enumerable).to_not be__loaded
        end
      end

      context "when added is not empty" do

        let!(:player_one) do
          team.players.create
        end

        let!(:player_two) do
          team.players.create
        end

        let(:last) do
          enumerable.last
        end

        context "when accessing from a reloaded child" do

          xit"returns the last document" do
            expect(player_one.reload.team.players.last).to eq(player_two)
          end
        end
      end
    end

    context "when the enumerable is loaded" do

      context "when loaded is not empty" do

        let!(:player) do
          Player.create(team_id: team.id.to_s)
        end

        let(:enumerable) do
          described_class.new([ player ])
        end

        let(:last) do
          enumerable.last
        end

        xit"returns the last loaded doc" do
          expect(last).to eq(player)
        end
      end

      context "when loaded is empty" do

        let!(:player) do
          Player.create(team_id: team.id.to_s)
        end

        let(:enumerable) do
          described_class.new([])
        end

        before do
          enumerable << player
        end

        let(:last) do
          enumerable.last
        end

        xit"returns the last added doc" do
          expect(last).to eq(player)
        end
      end

      context "when loaded and added are empty" do

        let(:enumerable) do
          described_class.new([])
        end

        let(:last) do
          enumerable.last
        end

        xit"returns nil" do
          expect(last).to be_nil
        end
      end
    end
  end

  describe "#kind_of?" do

    let(:enumerable) do
      described_class.new(Player.all)
    end

    context "when checking against enumerable" do

      xit"returns true" do
        expect(enumerable.kind_of?(::Enumerable)).to be true
      end
    end

    context "when checking against array" do

      xit"returns true" do
        expect(enumerable.kind_of?(Array)).to be true
      end
    end
  end

  describe "#load_all!" do

    let(:team) do
      Team.create
    end

    let!(:player) do
      Player.create(team_id: team.id.to_s)
    end

    let(:criteria) do
      Player.where(team_id: team.id.to_s)
    end

    let!(:enumerable) do
      described_class.new(criteria)
    end

    let!(:loaded) do
      enumerable.load_all!
    end

    xit"loads all the unloaded documents" do
      expect(enumerable._loaded).to eq({ player.id => player })
    end

    xit"returns the object" do
      expect(loaded).to eq([player])
    end

    xit"sets loaded to true" do
      expect(enumerable).to be__loaded
    end
  end

  describe "#reset" do

    let(:team) do
      Team.create
    end

    let(:player) do
      Player.create(team_id: team.id.to_s)
    end

    let(:player_two) do
      Player.create(team_id: team.id.to_s)
    end

    let(:enumerable) do
      described_class.new([ player ])
    end

    before do
      enumerable << player_two
    end

    let!(:reset) do
      enumerable.reset
    end

    xit"is not loaded" do
      expect(enumerable).to_not be__loaded
    end

    xit"clears out the loaded docs" do
      expect(enumerable._loaded).to be_empty
    end

    xit"clears out the added docs" do
      expect(enumerable._added).to be_empty
    end
  end

  describe "#respond_to?" do

    let(:enumerable) do
      described_class.new([])
    end

    context "when checking against array methods" do

      [].methods.each do |method|

        xit"returns true for #{method}" do
          expect(enumerable).to respond_to(method)
        end
      end
    end
  end

  describe "#size" do

    let(:team) do
      Team.create
    end

    let!(:player) do
      Player.create(team_id: team.id.to_s)
    end

    context "when the base is new" do

      let!(:team) do
        Team.new
      end

      context "when the added contains a persisted document" do

        let!(:player) do
          Player.create(team_id: team.id.to_s)
        end

        context "when the enumerable is not loaded" do

          let(:enumerable) do
            described_class.new(Player.where(team_id: team.id.to_s))
          end

          xit"includes the number of all added documents" do
            expect(enumerable.size).to eq(1)
          end
        end
      end
    end

    context "when the enumerable is loaded" do

      let(:enumerable) do
        described_class.new([ player ])
      end

      let(:player_two) do
        Player.new(team_id: team.id.to_s)
      end

      before do
        enumerable << player_two
      end

      let(:size) do
        enumerable.size
      end

      xit"returns the loaded size plus added size" do
        expect(size).to eq(2)
      end

      xit"matches the size of the loaded enumerable" do
        expect(size).to eq(enumerable.to_a.size)
      end
    end

    context "when the enumerable is not loaded" do

      let(:enumerable) do
        described_class.new(Player.where(team_id: team.id.to_s))
      end

      context "when the added contains new documents" do

        let(:player_two) do
          Player.new(team_id: team.id.to_s)
        end

        before do
          enumerable << player_two
        end

        let(:size) do
          enumerable.size
        end

        xit"returns the unloaded count plus added new size" do
          expect(size).to eq(2)
        end
      end

      context "when the added contains persisted documents" do

        let(:player_two) do
          Player.create(team_id: team.id.to_s)
        end

        before do
          enumerable << player_two
        end

        let(:size) do
          enumerable.size
        end

        xit"returns the unloaded count plus added new size" do
          expect(size).to eq(2)
        end
      end
    end
  end

  describe "#to_json" do

    let(:team) do
      Team.create
    end

    let!(:player) do
      Player.create(title: "test", team_id: team.id.to_s)
    end

    let(:criteria) do
      Player.where(team_id: team.id.to_s)
    end

    let!(:enumerable) do
      described_class.new(criteria)
    end

    before do
      enumerable << player
    end

    let!(:json) do
      enumerable.to_json
    end

    xit"serializes the enumerable" do
      expect(json).to include(player.title)
    end
  end

  describe "#to_json(parameters)" do

    let(:team) do
      Team.create
    end

    let!(:player) do
      Player.create(title: "test", team_id: team.id.to_s)
    end

    let(:criteria) do
      Player.where(team_id: team.id.to_s)
    end

    let!(:json) do
      team.players.to_json({except: 'title'})
    end

    xit"serializes the enumerable" do
      expect(json).to_not include(player.title)
    end
  end

  describe "#as_json" do

    let(:team) do
      Team.create
    end

    let!(:player) do
      Player.create(title: "test", team_id: team.id.to_s)
    end

    let(:criteria) do
      Player.where(team_id: team.id.to_s)
    end

    let!(:enumerable) do
      described_class.new(criteria)
    end

    before do
      enumerable << player
    end

    let!(:json) do
      enumerable.as_json
    end

    xit"serializes the enumerable" do
      expect(json.size).to eq(1)
      expect(json[0]['title']).to eq(player.title)
    end
  end

  describe "#as_json(parameters)" do

    let(:team) do
      Team.create
    end

    let!(:player) do
      Player.create(title: "test", team_id: team.id.to_s)
    end

    let(:criteria) do
      Player.where(team_id: team.id.to_s)
    end

    let!(:json) do
      team.players.as_json({except: "title"})
    end

    xit"serializes the enumerable" do
      expect(json.size).to eq(1)
    end

    xit"includes the proper fields" do
      expect(json[0].keys).to_not include("title")
    end
  end

  describe "#uniq" do

    let(:team) do
      Team.create
    end

    let!(:player) do
      Player.create(team_id: team.id.to_s)
    end

    let(:criteria) do
      Player.where(team_id: team.id.to_s)
    end

    let!(:enumerable) do
      described_class.new(criteria)
    end

    before do
      enumerable << player
      enumerable._loaded[player.id] = player
    end

    let!(:uniq) do
      enumerable.uniq
    end

    xit"returns the unique documents" do
      expect(uniq).to eq([ player ])
    end

    xit"sets loaded to true" do
      expect(enumerable).to be__loaded
    end
  end
end
