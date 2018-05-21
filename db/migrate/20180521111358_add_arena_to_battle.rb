class AddArenaToBattle < ActiveRecord::Migration[5.2]
  def change
    add_column :battles, :arena_id, :integer, default: 1
  end
end
