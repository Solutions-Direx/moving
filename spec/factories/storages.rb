# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :storage do
    sequence(:name) { |n| "user#{n}" }
    default false
    account
  end
end
