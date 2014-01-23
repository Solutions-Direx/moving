# encoding: utf-8
require 'faker'

account = Account.create!(
                          franchise_cancellation_amount: "20",
                          insurance_coverage_short_distance: "25000",
                          insurance_coverage_long_distance: "50000",
                          invoice_start_number: 100000
                         )
company = account.companies.build(
  company_name: "Déménagement DR",
  website: "http://demenagementdr.ca/",
  phone: '(819) 281-4000',
  invoice_header: "6145515 Canada Inc.

                   TPS: 875254302RT
                   TVQ: 1205180652"
)

company.build_address(address: "1713 Atmec - Local 1", city: "Gatineau", province: "Québec", postal_code: "J8R 0E7", country: "Canada")
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
default_tax = account.taxes.build(tax1_label: 'TPS', tax1: 5, tax2_label: "TVQ", tax2: 9.975, compound: false)
default_tax.is_default = true
default_tax.save!

ontario_tax = account.taxes.build(tax1_label: 'GST', tax1: 13, compound: false, province: "Ontario")
ontario_tax.save!