# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document do
    account
    sequence(:name) { |n| "Document #{n}" }
    body "MyText"
  end
end
