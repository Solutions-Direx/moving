# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    actor_id 1
    quote_id 1
    action "MyString"
    trackable_id 1
    trackable_type "MyString"
  end
end
