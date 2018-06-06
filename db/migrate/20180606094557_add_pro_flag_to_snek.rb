class AddProFlagToSnek < ActiveRecord::Migration[5.2]
  def change
    add_column :sneks, :pro, :boolean, default: false
    change_column :paid_subscriptions, :renewable, :boolean, default: true
  end
end
