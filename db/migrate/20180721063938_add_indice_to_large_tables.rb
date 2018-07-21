class AddIndiceToLargeTables < ActiveRecord::Migration[5.2]
  def change
    add_index :battles, :initiator_snek_id
    add_index :battles, :arena_id
    add_index :battles, :mode
    add_index :saved_battles, :user_id
    add_index :sneks, :user_id
  end
end
