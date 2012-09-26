# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :address do
    address Faker::Address.street_address
    city Faker::Address.city
    province Faker::Address.state
    postal_code Faker::Address.zip_code
    country "Canada"
  end
end
