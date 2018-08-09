class AddIndexToSnekBattleScore < ActiveRecord::Migration[5.2]
  def change
    add_index :snek_battles, [:snek_id, :score]
  end
end
