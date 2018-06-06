ActiveAdmin.register SubscriptionPayment do

  scope 'All', :all

  index do
    selectable_column
    id_column
    column :paid_subscription
    column :user
    column :amount
    column :created_at
    actions
  end

  filter :user
end
