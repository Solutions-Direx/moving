# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    address "MyString"
    city "MyString"
    province "MyString"
    postal_code "MyString"
    country "MyString"
  end
end
