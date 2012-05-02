# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    time_spent "MyString"
    comment "MyText"
    signer_name "MyString"
    signature "MyText"
  end
end
