class CreateDailyRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_ratings do |t|
      t.integer :snek_id
      t.date :date
      t.integer :position
      t.timestamps
    end
    add_index :daily_ratings, [:date]
    add_index :daily_ratings, [:snek_id]
    add_index :daily_ratings, [:snek_id, :date], unique: true
  end
end
