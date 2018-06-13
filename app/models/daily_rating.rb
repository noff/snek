class DailyRating < ApplicationRecord
  belongs_to :snek
  validates :date, :position, presence: true
  validates :position, numericality: {greater_than_or_equal_to: 0, only_integer: true}
end
