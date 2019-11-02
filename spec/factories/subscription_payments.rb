FactoryBot.define do
  factory :subscription_payment do
    paid_subscription_id  { 1 }
    user_id               { 1 }
    amount                { 1 }
  end
end
