class CreateBattles < ActiveRecord::Migration[5.2]
  def change
    create_table :battles do |t|
      t.string :aasm_state
      t.timestamps
    end
  end
end
