# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :room do
    account_id 1
    size "MyString"
    comment "MyText"
  end
end
