FactoryBot.define do
  factory :booking do
    start_at Date.current.in_time_zone
    end_at 5.days.from_now
    client_email 'tester@mail.com'
    price 100
    association :rental
  end
end
