require 'rails_helper'

RSpec.describe Battle, type: :model do

  let!(:user) { create(:user) }
  let!(:snek) { create(:snek, user: user) }

  context 'check state machine' do
    it 'creates battle as draft' do
      expect(Battle.new.draft?).to be_truthy
      expect(Battle.new.aasm_state).to eq 'draft'
    end
    it 'moves draft to running' do
      expect(Battle.new.run).to be_truthy
    end
    it 'can finish or fail running battle' do
      battle = Battle.new(initiator_snek_id: snek.id)
      battle.run
      expect(battle.finish).to be_truthy
      battle = Battle.new(initiator_snek_id: snek.id)
      battle.run
      expect(battle.fail('Test msg')).to be_truthy
    end
    it 'cant move draft to finished or failed' do
      expect{Battle.new.finish}.to raise_error AASM::InvalidTransition
      expect{Battle.new.fail}.to raise_error AASM::InvalidTransition
    end
    it 'cant move from finished or failed to running or draft' do
      battle = Battle.new(initiator_snek_id: snek.id)
      battle.run
      battle.finish
      expect{battle.run}.to raise_error AASM::InvalidTransition
      expect{battle.fail}.to raise_error AASM::InvalidTransition
      battle = Battle.new(initiator_snek_id: snek.id)
      battle.run
      battle.fail('Test msg')
      expect{battle.run(snek)}.to raise_error AASM::InvalidTransition
      expect{battle.finish}.to raise_error AASM::InvalidTransition
    end
  end

  context 'events and params' do

    it 'successfully starts and finished the battle' do
      battle = Battle.create(initiator_snek_id: snek.id)
      battle.start!
      battle.reload
      expect(battle.finished?).to be_truthy
    end

  end


end
