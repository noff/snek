class DailyRating < ApplicationRecord
  belongs_to :snek
  validates :date, :activity_score, :activity_position, :efficiency_score, :efficiency_position, presence: true
  validates :activity_position, :efficiency_position, numericality: {greater_than_or_equal_to: 0, only_integer: true}
end
