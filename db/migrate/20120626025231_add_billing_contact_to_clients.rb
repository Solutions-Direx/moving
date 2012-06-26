class AddBillingContactToClients < ActiveRecord::Migration
  def change
    add_column :clients, :billing_contact, :string
  end
end
