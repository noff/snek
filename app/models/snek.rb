class Snek < ApplicationRecord
  belongs_to :user
  validates :name, uniqueness: { case_sensitive: false }, presence: true, length: { minimum: 5 }
  validates :user_id, presence: true
end
