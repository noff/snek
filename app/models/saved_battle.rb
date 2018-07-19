class SavedBattle < ApplicationRecord
  belongs_to :user
  belongs_to :battle
  validates :user_id, :battle_id, presence: true
end
