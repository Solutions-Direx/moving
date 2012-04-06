# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quote do
    account_id 1
    client_id 1
    removal_at "2012-04-06 13:57:03"
    date "2012-04-06 13:57:03"
    is_house false
    nb_appliance 1
    num_of_removal_man 1
    price 1.5
    gas 1.5
    transport_at "2012-04-06 13:57:03"
    insurance false
    rating 1
    creator_id 1
  end
end
