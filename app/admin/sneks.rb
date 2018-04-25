ActiveAdmin.register Snek do

  index do
    selectable_column
    id_column
    column :name
    column :user
    column :created_at
    actions
  end

  filter :name
  filter :user

end
