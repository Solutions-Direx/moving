# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quote_deposit do
    quote_id 1
    amount 1.5
    date "2012-06-04"
    payment_method "MyString"
  end
end
