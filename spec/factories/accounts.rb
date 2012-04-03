# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    sequence(:company_name) { |n| "Company#{n}" }
  end
end
