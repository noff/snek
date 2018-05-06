class CreateArenas < ActiveRecord::Migration[5.2]
  def change
    create_table :arenas do |t|
      t.string :name, null: false
      t.jsonb :area, null: false
      t.timestamps
    end
  end
end
