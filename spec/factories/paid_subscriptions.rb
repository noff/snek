FactoryBot.define do
  factory :paid_subscription do
    user_id 1
    amount 1
    paid_till "2018-06-05"
    renewable false
  end
end
