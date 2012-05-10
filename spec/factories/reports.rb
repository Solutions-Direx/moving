# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :report do
    quote_id 1
    km_start "MyString"
    km_end "MyString"
    gas 1.5
    start_time "MyString"
    end_time "MyString"
    distance_in_qc "MyString"
    distance_in_on "MyString"
    distance_in_nb "MyString"
    distance_other "MyString"
    signer_name "MyString"
    signature "MyText"
  end
end
