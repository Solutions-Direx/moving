# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    invoice_id 1
    amount 1.5
    date "2012-07-15"
    payment_method "MyString"
    credit_card_type "MyString"
    transaction_number "MyString"
  end
end
