print "Rental: "
20.times do
  rental = Rental.create! name: "#{Faker::Address.city} #{Faker::Address.street_address}",
                          daily_rate: Faker::Number.decimal(2,2)
  rental.save
  print '.'
end
puts