# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120626025231) do

  create_table "accounts", :force => true do |t|
    t.string   "company_name"
    t.string   "logo"
    t.string   "tax1_label"
    t.float    "tax1"
    t.string   "tax2_label"
    t.float    "tax2"
    t.boolean  "compound"
    t.string   "phone"
    t.string   "website"
    t.string   "email"
    t.float    "franchise_cancellation_amount"
    t.float    "insurance_coverage_short_distance"
    t.float    "insurance_coverage_long_distance"
    t.integer  "invoice_start_number"
    t.boolean  "rebase_invoice_number",             :default => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  create_table "addresses", :force => true do |t|
    t.string   "address"
    t.string   "city"
    t.string   "province"
    t.string   "postal_code"
    t.string   "country"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "addresses", ["addressable_id"], :name => "index_addresses_on_addressable_id"
  add_index "addresses", ["addressable_type"], :name => "index_addresses_on_addressable_type"

  create_table "annexes", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "storage_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email"
    t.boolean  "commercial",      :default => false
    t.integer  "account_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "billing_contact"
  end

  add_index "clients", ["phone1"], :name => "index_clients_on_phone1"
  add_index "clients", ["phone2"], :name => "index_clients_on_phone2"

  create_table "documents", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "forfaits", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.float    "price"
    t.integer  "account_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "furnitures", :force => true do |t|
    t.integer  "num_appliances"
    t.integer  "kitchen_table"
    t.integer  "kitchen_chair"
    t.integer  "kitchen_buffet"
    t.integer  "living_couch_3pl"
    t.integer  "living_couch_2pl"
    t.integer  "living_armchair"
    t.integer  "living_table"
    t.integer  "living_wall_unit"
    t.integer  "living_tv"
    t.string   "living_other"
    t.integer  "base_salon"
    t.integer  "base_shelf"
    t.integer  "base_desk"
    t.integer  "base_training"
    t.string   "base_other"
    t.integer  "outside_tire"
    t.integer  "outside_lawn_mower"
    t.integer  "outside_bike"
    t.integer  "outside_table"
    t.integer  "outside_bbq"
    t.string   "outside_other"
    t.integer  "quote_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "invoice_forfaits", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "forfait_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invoice_supplies", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "supply_id"
    t.integer  "quantity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invoices", :force => true do |t|
    t.integer  "code"
    t.integer  "quote_id"
    t.integer  "client_id"
    t.float    "time_spent"
    t.text     "comment"
    t.string   "signer_name"
    t.text     "signature"
    t.datetime "signed_at"
    t.float    "rate"
    t.float    "gas"
    t.string   "tax1_label"
    t.float    "tax1"
    t.string   "tax2_label"
    t.float    "tax2"
    t.boolean  "compound"
    t.text     "client_satisfaction"
    t.string   "payment_method"
    t.float    "discount"
    t.string   "credit_card_type"
    t.integer  "lock_version",         :default => 0
    t.integer  "integer",              :default => 0
    t.float    "tip"
    t.string   "furnitures"
    t.boolean  "too_big_for_stairway"
    t.boolean  "too_big_for_hallway"
    t.boolean  "too_big"
    t.boolean  "broken"
    t.boolean  "too_fragile"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "overtimes", :force => true do |t|
    t.integer  "invoice_id"
    t.float    "duration"
    t.float    "rate"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pg_search_documents", :force => true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "quote_addresses", :force => true do |t|
    t.integer  "quote_id"
    t.string   "type"
    t.integer  "storage_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "quote_confirmations", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "user_id"
    t.datetime "approved_at"
    t.string   "payment_method"
    t.boolean  "franchise_cancellation"
    t.boolean  "insurance_limit_enough"
    t.float    "insurance_increase"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "quote_deposits", :force => true do |t|
    t.integer  "quote_id"
    t.float    "amount"
    t.date     "date"
    t.string   "payment_method"
    t.string   "credit_card_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "quote_documents", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "document_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "quote_forfaits", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "forfait_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "quote_removal_men", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "removal_man_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "quote_supplies", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "supply_id"
    t.integer  "quantity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "quote_trucks", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "truck_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "quotes", :force => true do |t|
    t.string   "code"
    t.integer  "account_id"
    t.integer  "client_id"
    t.string   "phone1"
    t.string   "phone2"
    t.datetime "removal_at"
    t.string   "removal_at_comment"
    t.datetime "date"
    t.boolean  "is_house",           :default => true
    t.boolean  "materiel"
    t.integer  "num_of_removal_man"
    t.float    "price"
    t.float    "gas"
    t.string   "transport_time"
    t.boolean  "insurance"
    t.string   "rating",             :default => "A"
    t.integer  "creator_id"
    t.string   "status",             :default => "pending"
    t.text     "comment"
    t.boolean  "pm",                 :default => false
    t.boolean  "long_distance",      :default => false
    t.integer  "removal_leader_id"
    t.boolean  "internal_address",   :default => false
    t.string   "signer_name"
    t.text     "signature"
    t.datetime "signed_at"
    t.integer  "lock_version",       :default => 0
    t.integer  "integer",            :default => 0
    t.string   "contact"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "rejected_by"
    t.datetime "rejected_at"
  end

  create_table "report_removal_men", :force => true do |t|
    t.integer  "report_id"
    t.integer  "removal_man_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "reports", :force => true do |t|
    t.integer  "quote_id"
    t.float    "km_start"
    t.float    "km_end"
    t.float    "gas"
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "distance_in_qc"
    t.float    "distance_in_on"
    t.float    "distance_in_nb"
    t.float    "distance_other"
    t.string   "signer_name"
    t.text     "signature"
    t.datetime "signed_at"
    t.text     "comment"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "rooms", :force => true do |t|
    t.integer  "quote_id"
    t.string   "size"
    t.text     "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "storages", :force => true do |t|
    t.string   "name"
    t.boolean  "internal",   :default => false
    t.float    "price"
    t.integer  "account_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "supplies", :force => true do |t|
    t.string   "name"
    t.boolean  "active",     :default => true
    t.float    "price"
    t.integer  "account_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "trucks", :force => true do |t|
    t.string   "name"
    t.string   "plate"
    t.boolean  "available",  :default => true
    t.integer  "account_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "active",                 :default => true
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "account_id"
    t.string   "role"
    t.boolean  "account_owner",          :default => false
    t.string   "localization",           :default => "fr"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
