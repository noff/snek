class AddInitiatorSnekToBattle < ActiveRecord::Migration[5.2]
  def change
    add_column :battles, :initiator_snek_id, :integer
  end
end
