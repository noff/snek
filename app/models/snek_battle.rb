class SnekBattle < ApplicationRecord
  paginates_per 50
  belongs_to :snek
  belongs_to :battle
end
