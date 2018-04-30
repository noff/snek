class AddRulesToSnek < ActiveRecord::Migration[5.2]
  def change
    add_column :sneks, :rules, :jsonb
  end
end
