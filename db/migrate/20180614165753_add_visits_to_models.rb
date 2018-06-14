class AddVisitsToModels < ActiveRecord::Migration[5.2]
  def change
    add_column :sneks, :visit_id, :bigint
    add_column :battles, :visit_id, :bigint
    add_index :sneks, :visit_id
    add_index :battles, :visit_id
  end
end
