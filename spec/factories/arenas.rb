FactoryBot.define do
  factory :arena do
    id            FFaker::Internet.rand(10000000)
    name          'Fort Square'
    area          Arena.default_arena
  end
end