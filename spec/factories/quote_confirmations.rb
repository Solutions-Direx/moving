# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quote_confirmation do
    quote_id 1
    user_id 1
    approved_at "2012-04-13 14:05:35"
    franchise_cancellation false
    insurance_limit_enough true
    insurance_increase false
  end
end
