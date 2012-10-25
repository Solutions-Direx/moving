# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice_line do
    amount 1.5
    invoiceable_type "MyString"
    invoiceable_id 1
  end
end
