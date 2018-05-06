require 'rails_helper'

RSpec.describe Snek, type: :model do

  let!(:user) { create(:user) }
  let!(:snek) { create(:snek, user_id: user.id) }

  context 'creation' do
    it 'saves new snek with default rules' do
      expect(snek.rules).to eq 9.times.map { [ [ ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and']], [ ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and']], [ ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and']], [ ['default', 'and'], ['default', 'and'], ['default', 'and'], ['my_head', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and']], [ ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and']], [ ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and']], [ ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and']] ] }
    end
  end



end
