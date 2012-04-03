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

# generate 20 standard users
10.times do |x|
  print '.'
  count = x + 1
  account.users.create!(username: "standard#{count}", first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "standard#{count}@gmail.com", password: "123123", password_confirmation: "123123", role: User::Role::STANDARD)
end
print "\n"
puts "Generated 10 standard users."

# generate 50 removal men
50.times do |x|
  print '.'
  count = x + 1
  account.users.create!(username: "removal_man#{count}", first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "removal_man#{count}@gmail.com", password: "123123", password_confirmation: "123123", role: User::Role::REMOVAL_MAN)
end
print "\n"
puts "Generated 50 removal men."