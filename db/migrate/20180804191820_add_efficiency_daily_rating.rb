class AddEfficiencyDailyRating < ActiveRecord::Migration[5.2]
  def change
    rename_column :daily_ratings, :position, :activity_position
    add_column :daily_ratings, :efficiency_position, :integer
    rename_column :daily_ratings, :score, :activity_score
    add_column :daily_ratings, :efficiency_score, :integer, default: 0
  end
end
