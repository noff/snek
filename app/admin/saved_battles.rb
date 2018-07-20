ActiveAdmin.register SavedBattle do

  scope 'All', :all

  index do
    selectable_column
    id_column
    column :user
    column :battle
    column :created_at
    column :updated_at
    actions
  end

  filter :user
end
