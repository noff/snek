class AddScoreToDailyRating < ActiveRecord::Migration[5.2]
  def change
    add_column :daily_ratings, :score, :integer, default: 0
  end
end
