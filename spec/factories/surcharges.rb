# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :surcharge do
    invoice_id 1
    label "MyString"
    price ""
  end
end
