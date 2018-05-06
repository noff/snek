FactoryBot.define do
  factory :snek do
    name        FFaker::Name.last_name
  end
end