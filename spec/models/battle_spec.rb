require 'rails_helper'

RSpec.describe Battle, type: :model do
  context 'check state machine' do
    it 'creates battle as draft' do
      expect(Battle.new.draft?).to be_truthy
      expect(Battle.new.aasm_state).to eq 'draft'
    end
    it 'moves draft to running' do
      expect(Battle.new.run).to be_truthy
    end
    it 'can finish or fail running battle' do
      battle = Battle.new
      battle.run
      expect(battle.finish).to be_truthy
      battle = Battle.new
      battle.run
      expect(battle.fail).to be_truthy
    end
    it 'cant move draft to finished or failed' do
      expect{Battle.new.finish}.to raise_error AASM::InvalidTransition
      expect{Battle.new.fail}.to raise_error AASM::InvalidTransition
    end
    it 'cant move from finished or failed to running or draft' do
      battle = Battle.new
      battle.run
      battle.finish
      expect{battle.run}.to raise_error AASM::InvalidTransition
      expect{battle.fail}.to raise_error AASM::InvalidTransition
      battle = Battle.new
      battle.run
      battle.fail
      expect{battle.run}.to raise_error AASM::InvalidTransition
      expect{battle.finish}.to raise_error AASM::InvalidTransition
    end
  end
end
