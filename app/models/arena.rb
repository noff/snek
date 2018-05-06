class Arena < ApplicationRecord
  validates :name, :area, presence: true
end
