FactoryBot.define do
  factory :user do
    email                   FFaker::Internet.email
    password                'XziiG8nreVg'
    password_confirmation   'XziiG8nreVg'
  end
end