# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :option do
    sequence(:name) { |n| "Option#{n}" }
    active false
    price 1.5
    account
  end
end
