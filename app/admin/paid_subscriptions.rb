ActiveAdmin.register PaidSubscription do

  scope 'All', :all

  index do
    selectable_column
    id_column
    column :user
    column :amount
    column :paid_till
    column :renewable
    column :stripe_id
    column :product
    column :created_at
    actions
  end

  filter :user
end
