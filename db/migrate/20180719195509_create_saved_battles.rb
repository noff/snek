class CreateSavedBattles < ActiveRecord::Migration[5.2]
  def change
    create_table :saved_battles do |t|
      t.integer :battle_id
      t.integer :user_id

      t.timestamps
    end
    add_index :saved_battles, [:user_id, :battle_id], unique: true
  end
end
