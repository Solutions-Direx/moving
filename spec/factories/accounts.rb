# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    sequence(:company_name) { |n| "Company#{n}" }
    tax1_label "TPS"
    tax1 10
    tax2_label "TVQ"
    tax2 5
    compound false
    phone "123-123-123"
    website "moving.com"
    email "support@moving.com"
    franchise_cancellation_amount "20"
    insurance_coverage_short_distance "25000"
    insurance_coverage_long_distance "50000"
  end
end
