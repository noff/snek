ActiveAdmin.register Battle do

  index do
    id_column
    column :created_at
    column :updated_at
  end

  show do
    attributes_table do
      row :id
      row :snek
      row :created_at
      row :updated_at
    end

    panel 'Sneks' do
      table_for battle.snek_battles do
        column :snek do |s|
          link_to s.snek, [:admin, s.snek]
        end
      end
    end
  end

end
