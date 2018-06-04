class AddCurrentBattlesCount < ActiveRecord::Migration[5.2]
  def change
    add_column :sneks, :current_battles_count, :integer, default: 0
  end
end
