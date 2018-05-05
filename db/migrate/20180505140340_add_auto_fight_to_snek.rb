class AddAutoFightToSnek < ActiveRecord::Migration[5.2]
  def change
    add_column :sneks, :auto_fight, :boolean, default: false
  end
end
