# encoding: utf-8
require 'faker'

puts "GENERATE SAMPLE DATA ..."

account = Account.first
account.update_attributes(
  accounting_moving_account_number: "4200",
  accounting_tip_account_number: "4206",
  accounting_insurance_account_number: "4210",
  accounting_supply_account_number: "4207"
)

company = account.companies.build(
  company_name: "Déménagement Minimum",
  website: "http://demenagementdr.ca/",
  phone: '(819) 281-4000',
  invoice_header: "Déménagement DR
  1713 Atmec - Local 1
  Gatineau, QC, J8R 0E7
  TPS: 875254302RT
  TVQ: 1205180652

  Tél: (819) 281-4000"
)

company.build_address(address: "1713 Atmec - Local 1", city: "Gatineau", province: "Québec", postal_code: "J8R0E7", country: "Canada")
company.save!

puts "Generated 1 company."


# generate 3 managers
3.times do |x|
  print '.'
  count = x + 1
  account.users.create!(username: "manager#{count}", first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, 
                        email: "manager#{count}@gmail.com", password: "123123", password_confirmation: "123123", role: User::Role::MANAGER
                        )
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


# generate 10 removal men
10.times do |x|
  print '.'
  count = x + 1
  account.users.create!(username: "removal_man#{count}", first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "removal_man#{count}@gmail.com", password: "123123", password_confirmation: "123123", role: User::Role::REMOVAL_MAN)
end
print "\n"
puts "Generated 10 sample removal men."


# generate 50 clients
50.times do |x|
  print '.'
  count = x + 1
  client = account.clients.create!(name: Faker::Name.name, email: Faker::Internet.email, phone1: Faker::PhoneNumber.phone_number, phone2: Faker::PhoneNumber.phone_number, commercial: [true, false].sample)
  client.create_address!(address: Faker::Address.street_address(include_secondary = false), city: Faker::Address.city, postal_code: Faker::Address.zip_code, province: ['Québec', 'Ontario', 'New York'].sample, country: 'Canada')
end
print "\n"
puts "Generated 50 sample clients."


# generate 10 trucks
10.times do |x|
  print '.'
  count = x + 1
  account.trucks.create!(name: Faker::Lorem.words(2).join(' ').titleize, plate: ['22367 SLV', '11145 RTY', '45093 CVB', '84556 CVB'].sample)
end
print "\n"
puts "Generated 10 sample trucks."


# generate 10 documents
10.times do |x|
  print '.'
  count = x + 1
  account.documents.create!(name: Faker::Lorem.words(5).join(' ').titleize, body: Faker::Lorem.paragraphs(3).join("<br/>"), default: [true, false].sample)
end
print "\n"
puts "Generated 10 sample documents."


# generate 5 storages
5.times do |x|
  print '.'
  count = x + 1
  storage = account.storages.create!(name: Faker::Lorem.words(2).join(' ').titleize, internal: [true, false].sample)
  storage.create_address(address: Faker::Address.street_address(include_secondary = false), city: Faker::Address.city, postal_code: Faker::Address.zip_code, province: ['Québec', 'Ontario', 'New York'].sample, country: 'Canada')
end
s_internal = Storage.first
s_internal.update_attributes(name: "Entrepôt interne", price: '20', internal: true)
s_internal.annexes.create([{name: 'Conditions', body: 'Coming up...'}, {name: 'Assurances', body: 'Coming up...'}])
print "\n"
puts "Generated 5 sample storages."


# generate 3 forfaits
3.times do |x|
  print '.'
  count = x + 1
  account.forfaits.create!(name: Faker::Lorem.words(2).join(' ').titleize, description: "Coming soon..", price: ['240', '50', '149.99'].sample)
end
print "\n"
puts "Generated 3 sample forfaits."

3.times do |x|
  print '.'
  count = x + 1
  account.supplies.create!(name: Faker::Lorem.words(2).join(' ').titleize, price: ['240', '50', '149.99'].sample)
end
print "\n"
puts "Generated 3 sample supplies."


# generate 50 quotes
50.times do |x|
  print '.'
  count = x + 1
  client = Client.find(count)
  c = Company.all.sample
  creator_id = User.managers.all.sample.id
  quote = c.quotes.build(client_id: client.id, 
                         creator_id: creator_id, 
                         sale_representative_id: creator_id, 
                         removal_at: Time.now + [0,5,10,15,20].sample.days, 
                         date: Time.now,
                         phone1: client.phone1,
                         phone2: client.phone2,
                         is_house: [true, false].sample,
                         num_of_removal_man: (2..5).to_a.sample,
                         price: (100..500).to_a.sample,
                         gas: (30..100).to_a.sample,
                         rating: ['A', 'B', 'C'].sample,
                         pm: [true, false].sample,
                         )
  quote.account_id = c.account_id
  # room
  quote.rooms.build(size: Room::SIZES.sample)
  # from address
  quote.build_from_address.build_address(client.address.attributes.slice("address", "city", "province", "postal_code", "country"))
  [1,2].sample.times do
    quote.to_addresses.build.build_address(address: Faker::Address.street_address(include_secondary = false), city: Faker::Address.city, postal_code: Faker::Address.zip_code, province: ['Québec', 'Ontario', 'New York'].sample, country: 'Canada')
  end
  # truck
  quote.trucks = [Truck.all.sample]
  
  # documents
  quote.documents = [Document.all.sample]
  
  quote.save!
end
print "\n"
puts "Generated 50 sample quotes."
puts "DONE"
