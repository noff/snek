class AddCountryToSnek < ActiveRecord::Migration[5.2]
  def change
    add_column :sneks, :country, :string
  end
end
