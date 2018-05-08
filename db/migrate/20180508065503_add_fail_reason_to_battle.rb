class AddFailReasonToBattle < ActiveRecord::Migration[5.2]
  def change
    add_column :battles, :fail_reason, :string
  end
end
