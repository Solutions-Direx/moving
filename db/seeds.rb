# encoding: utf-8
require 'faker'

account = Account.create!(company_name: "Déménagement Maximum",
                          website: "http://demenagementmaximum.com/",
                          phone: '(819) 777-6683',
                          franchise_cancellation_amount: "20",
                          insurance_coverage_short_distance: "25000",
                          insurance_coverage_long_distance: "50000",
                          tax1_label: "TPS", 
                          tax1: 5, 
                          tax2_label: "TVQ", 
                          tax2: 9.5,
                          compound: true,
                          invoice_start_number: 10000
                         )
owner = account.users.build(username: "super", 
                            first_name: Faker::Name.first_name, 
                            last_name: Faker::Name.last_name, 
                            email: "super@gmail.com", 
                            password: "123123", 
                            password_confirmation: "123123", 
                            role: User::Role::MANAGER
                            )
owner.account_owner = true
owner.save!