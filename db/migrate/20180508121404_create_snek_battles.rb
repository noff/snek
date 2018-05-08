class CreateSnekBattles < ActiveRecord::Migration[5.2]
  def change
    create_table :snek_battles do |t|
      t.integer :snek_id
      t.integer :battle_id
      t.integer :score, default: 0

      t.timestamps
    end
  end
end
