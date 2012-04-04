# encoding: utf-8
require 'faker'

account = Account.create!(company_name: "Déménagement Maximum")
owner = account.users.build(username: "super", first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "super@gmail.com", password: "123123", password_confirmation: "123123", role: User::Role::MANAGER)
owner.account_owner = true
owner.save