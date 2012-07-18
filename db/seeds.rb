# encoding: utf-8
require 'faker'

account = Account.create!(
                          franchise_cancellation_amount: "20",
                          insurance_coverage_short_distance: "25000",
                          insurance_coverage_long_distance: "50000",
                          invoice_start_number: 100000
                         )
company = account.companies.build(
  company_name: "Déménagement Maximum",
  website: "http://demenagementmaximum.com/",
  phone: '(819) 777-6683'
)

company.build_address(address: "266 St-Louis - Unité 9", city: "Gatineau", province: "Québec", postal_code: "J8P 8B3", country: "Canada")
company.save!

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

# default tax
default_tax = account.taxes.build(tax1_label: 'TPS', tax1: 5,tax2_label: "TVQ", tax2: 9.5, compound: true)
default_tax.is_default = true
default_tax.save!

ontario_tax = account.taxes.build(tax_name: 'Ontario Tax', tax_rate: 13, province: "Ontario")
ontario_tax.save!
tps_tax = account.taxes.build(tax_name: 'TPS', tax_rate: 5, province: "Québec")
tps_tax.save!
tvq_tax = account.taxes.build(tax_name: 'TVQ', tax_rate: '9.5', province: "Québec")
tvq_tax.save!