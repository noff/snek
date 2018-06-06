class CreatePaidSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :paid_subscriptions do |t|
      t.integer :user_id
      t.integer :amount
      t.date :paid_till
      t.boolean :renewable
      t.string :stripe_id
      t.timestamps
    end
  end
end
