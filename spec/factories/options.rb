# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :option do
    name "MyString"
    active false
    price 1.5
    account_id 1
  end
end
