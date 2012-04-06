# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :client do
    sequence(:name) { |n| "Client#{n}" }
    phone1 Faker::PhoneNumber.phone_number
    phone2 Faker::PhoneNumber.phone_number
    email Faker::Internet.email
    account
  end
end
