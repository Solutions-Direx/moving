# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :taxis, :class => 'Tax' do
    province "MyString"
    account_id 1
    tax_name "MyString"
    tax_rate 1.5
  end
end
