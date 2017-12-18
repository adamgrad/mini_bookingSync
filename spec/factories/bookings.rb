FactoryBot.define do
  factory :booking do
    start_at Date.current.in_time_zone
    end_at 5.days.from_now
    sequence(:client_email) { |n| "tester#{n}@mail.com"}
    price 100
    association :rental
  end
end
