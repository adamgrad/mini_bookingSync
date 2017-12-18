FactoryBot.define do
  factory :rental do
    sequence(:name) { |n| "Test Rental #{n}"}
    daily_rate 15

    trait :invalid_name do
      name nil
    end

    trait :invalid_daily_rate do
      daily_rate nil
    end
  end
end
