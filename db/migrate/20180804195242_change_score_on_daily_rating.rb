class ChangeScoreOnDailyRating < ActiveRecord::Migration[5.2]
  def change
    change_column :daily_ratings, :efficiency_score, :decimal
  end
end
