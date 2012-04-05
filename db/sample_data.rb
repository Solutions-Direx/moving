# encoding: utf-8
require 'faker'

account = Account.first

# generate 3 managers
3.times do |x|
  print '.'
  count = x + 1
  account.users.create!(username: "manager#{count}", first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "manager#{count}@gmail.com", password: "123123", password_confirmation: "123123", role: User::Role::MANAGER)
end
print "\n"
puts "Generated 3 managers."

# generate 10 standard users
10.times do |x|
  print '.'
  count = x + 1
  account.users.create!(username: "standard#{count}", first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "standard#{count}@gmail.com", password: "123123", password_confirmation: "123123", role: User::Role::STANDARD)
end
print "\n"
puts "Generated 10 standard users."

# generate 30 removal men
30.times do |x|
  print '.'
  count = x + 1
  account.users.create!(username: "removal_man#{count}", first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "removal_man#{count}@gmail.com", password: "123123", password_confirmation: "123123", role: User::Role::REMOVAL_MAN)
end
print "\n"
puts "Generated 30 removal men."

# generate 50 clients
50.times do |x|
  print '.'
  count = x + 1
  account.clients.create!(name: Faker::Name.name, email: Faker::Internet.email, phone1: Faker::PhoneNumber.phone_number, phone2: Faker::PhoneNumber.phone_number)
  Address.create!(address: Faker::Address.street_address(include_secondary = false), city: Faker::Address.city, postal_code: Faker::Address.zip_code, province: ['Québec', 'Ontario', 'New York'].sample, country: 'Canada', addressable_id: "#{count}", addressable_type: "Client")
end
print "\n"
puts "Generated 50 clients."