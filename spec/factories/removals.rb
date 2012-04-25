# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :removal do
    quote_id 1
    payment_method "MyString"
    franchise_cancellation false
    insurance_limit_enough false
    insurance_increase 1.5
    signature "MyText"
  end
end
