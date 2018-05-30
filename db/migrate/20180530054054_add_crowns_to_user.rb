class AddCrownsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :crowns, :integer, default: 0
  end
end
