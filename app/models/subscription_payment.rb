class SubscriptionPayment < ApplicationRecord
  belongs_to :paid_subscription
  belongs_to :user
  validates :amount, numericality: { only_integer: true, greater_than: 0 }
end
