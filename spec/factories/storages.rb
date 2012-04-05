# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :storage do
    name "MyString"
    default false
    account_id "MyString"
  end
end
