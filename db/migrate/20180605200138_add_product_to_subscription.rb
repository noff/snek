class AddProductToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :paid_subscriptions, :product, :string
  end
end
