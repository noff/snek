class CreateBattleRounds < ActiveRecord::Migration[5.2]
  def change
    create_table :battle_rounds do |t|
      t.integer :battle_id
      t.integer :round_number
      t.jsonb :arena
      t.jsonb :sneks
      t.timestamps
    end
  end
end
