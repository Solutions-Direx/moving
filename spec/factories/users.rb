FactoryGirl.define do
  factory :user, aliases: [:owner] do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:first_name) { |n| "First #{n}" }
    sequence(:last_name) { |n| "Last #{n}" }
    password "123123"
    password_confirmation "123123"
    role 'standard'
    account
    
    factory :manager do
      role 'manager'
    end
    
    factory :account_owner do
      role 'manager'
      account_owner true
    end
    
    factory :standard do
      role 'standard'
    end
    
    factory :removal_man do
      role 'removal_man'
    end
    
    factory :inactive_user do
      active false
    end
  end
end
