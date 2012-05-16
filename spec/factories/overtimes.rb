# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :overtime do
    invoice_id 1
    duration 1.5
    rate 1.5
  end
end
