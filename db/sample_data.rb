# encoding: utf-8
require 'faker'

puts "GENERATE SAMPLE DATA ..."
account = Account.first

# generate 3 managers
3.times do |x|
  print '.'
  count = x + 1
  account.users.create!(username: "manager#{count}", first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "manager#{count}@gmail.com", password: "123123", password_confirmation: "123123", role: User::Role::MANAGER)
end
print "\n"
puts "Generated 3 sample managers."

# generate 10 standard users
10.times do |x|
  print '.'
  count = x + 1
  account.users.create!(username: "standard#{count}", first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "standard#{count}@gmail.com", password: "123123", password_confirmation: "123123", role: User::Role::STANDARD)
end
print "\n"
puts "Generated 10 sample standard users."

# generate 20 removal men
20.times do |x|
  print '.'
  count = x + 1
  account.users.create!(username: "removal_man#{count}", first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "removal_man#{count}@gmail.com", password: "123123", password_confirmation: "123123", role: User::Role::REMOVAL_MAN)
end
print "\n"
puts "Generated 20 sample removal men."

# generate 50 clients
50.times do |x|
  print '.'
  count = x + 1
  client = account.clients.create!(name: Faker::Name.name, email: Faker::Internet.email, phone1: Faker::PhoneNumber.phone_number, phone2: Faker::PhoneNumber.phone_number)
  client.create_address!(address: Faker::Address.street_address(include_secondary = false), city: Faker::Address.city, postal_code: Faker::Address.zip_code, province: ['Québec', 'Ontario', 'New York'].sample, country: 'Canada')
end
print "\n"
puts "Generated 50 sample clients."

# generate 10 trucks
10.times do |x|
  print '.'
  count = x + 1
  account.trucks.create!(name: Faker::Lorem.words(2).join(' ').titleize, plate: Faker::PhoneNumber.phone_number)
end
print "\n"
puts "Generated 10 sample trucks."


# generate 5 storages
5.times do |x|
  print '.'
  count = x + 1
  storage = account.storages.create!(name: Faker::Lorem.words(2).join(' ').titleize, internal: [true, false].sample)
  storage.create_address(address: Faker::Address.street_address(include_secondary = false), city: Faker::Address.city, postal_code: Faker::Address.zip_code, province: ['Québec', 'Ontario', 'New York'].sample, country: 'Canada')
end
s_internal = Storage.find_by_internal(true)
s_internal.update_attributes(price: '20')
s_internal.annexes.create([{name: 'Conditions', body: 'Coming up...'}, {name: 'Assurances', body: 'Coming up...'}])
print "\n"
puts "Generated 5 sample storages."


# generate 5 quotes
5.times do |x|
  print '.'
  count = x + 1
  client = Client.find(count)
  quote = account.quotes.build(client_id: client.id, 
                               creator_id: User.first.id, 
                               removal_at: Time.now + [5,10,15,20].sample.days, 
                               date: Time.now,
                               phone1: client.phone1,
                               phone2: client.phone2,
                               is_house: [true, false].sample,
                               num_of_removal_man: (2..5).to_a.sample,
                               price: (100..500).to_a.sample,
                               gas: (30..100).to_a.sample,
                               rating: ['A', 'B', 'C'].sample)
  # room
  quote.rooms.build(size: Room::SIZES.sample)
  # from address
  quote.build_from_address.build_address(client.address.attributes.slice("address", "city", "province", "postal_code", "country"))
  quote.build_to_address1.build_address(address: Faker::Address.street_address(include_secondary = false), city: Faker::Address.city, postal_code: Faker::Address.zip_code, province: ['Québec', 'Ontario', 'New York'].sample, country: 'Canada')
  # truck
  quote.trucks = [Truck.all.sample]
  quote.save!
end
print "\n"
puts "Generated 5 sample quotes."
puts "DONE."
