class AddStripeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :stripe_id, :string
  end
end
