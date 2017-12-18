FactoryBot.define do
  factory :rental do
    sequence(:name) { |n| "Test Rental #{n}"}
    daily_rate 15
  end
end
