ActiveAdmin.register Snek do

  scope 'All', :all
  scope 'Autofight', :for_autofight

  index do
    selectable_column
    id_column
    column :name
    column :user
    column :created_at
    column :current_battles_count
    actions do |snek|
      link_to 'Reset count', reset_count_admin_snek_path(snek), method: :put
    end
  end

  filter :name
  filter :user


  member_action :reset_count, method: :put do
    resource.update current_battles_count: 0
    redirect_to admin_sneks_path, notice: "Counter reset!"
  end


end
