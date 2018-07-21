ActiveAdmin.register User do
  permit_params :email

  index do
    selectable_column
    id_column
    column :email
    column :sneks do |u|
      u.sneks.count
    end
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
    end
    f.actions
  end


  show do
    attributes_table do
      row :email
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :created_at
      row :updated_at
      row :crowns
      row :stripe_id
    end

    panel 'Sneks' do
      table_for user.sneks do
        column :id
        column :name do |s|
          link_to s.name, [:admin, s]
        end
        column :current_battles_count
      end
    end
  end

end
