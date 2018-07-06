ActiveAdmin.register PaidSubscription do

  permit_params :amount, :paid_till, :renewable, :product

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

  form do |f|
    f.inputs do
      f.input :amount
      f.input :paid_till
      f.input :renewable
      f.input :product
    end
    f.actions
  end

  filter :user
end
