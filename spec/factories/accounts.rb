# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    sequence(:company_name) { |n| "Company#{n}" }
    tax1_label ""
    tax1 10
    tax2_label ""
    tax2 5
    compound false
    phone "123-123-123"
    website "moving.com"
    email "support@moving.com"
  end
end
