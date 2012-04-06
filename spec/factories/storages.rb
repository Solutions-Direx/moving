# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :storage do
    sequence(:name) { |n| "storage#{n}" }
    default false
    account
  end
end
