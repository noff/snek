class AddIndice < ActiveRecord::Migration[5.2]
  def change
    add_index :battle_rounds, :battle_id
    add_index :battles, :aasm_state
    add_index :snek_battles, :snek_id
    add_index :snek_battles, :battle_id
  end
end
