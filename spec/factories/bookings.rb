FactoryBot.define do
  factory :booking do
    start_at Date.current.in_time_zone
    end_at 5.days.from_now
    sequence(:client_email) { |n| "tester#{n}@mail.com"}
    price 100
    association :rental

    trait :invalid_start_at do
      start_at nil
    end

    trait :invalid_end_at do
      end_at nil
    end

    trait :invalid_price do
      price nil
    end

    trait :invalid_client_email do
      client_email nil
    end

    trait :ends_before_start_at do
      start_at Date.current.in_time_zone
      end_at 1.days.ago
    end
  end
end
