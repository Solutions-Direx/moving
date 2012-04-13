# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :forfait do
    name "MyString"
    description "MyText"
    price 1.5
    account_id 1
  end
end
