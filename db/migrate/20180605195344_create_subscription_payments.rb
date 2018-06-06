class CreateSubscriptionPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :subscription_payments do |t|
      t.integer :paid_subscription_id
      t.integer :user_id
      t.integer :amount

      t.timestamps
    end
  end
end
