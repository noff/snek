class AddModeToBattle < ActiveRecord::Migration[5.2]
  def change
    add_column :battles, :mode, :integer, default: BattleMode::DEFAULT
  end
end
