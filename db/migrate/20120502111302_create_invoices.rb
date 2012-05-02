class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :removal_id
      t.integer :quote_id
      t.string :time_spent
      t.text :comment
      t.string :signer_name
      t.text :signature
      t.datetime :signed_at

      t.timestamps
    end
  end
end
