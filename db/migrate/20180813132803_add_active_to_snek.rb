class AddActiveToSnek < ActiveRecord::Migration[5.2]
  def change
    add_column :sneks, :active, :boolean, default: true
  end
end
