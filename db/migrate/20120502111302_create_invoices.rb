class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :code
      t.integer :quote_id
      t.integer :client_id
      t.float :time_spent
      t.text :comment
      t.string :signer_name
      t.text :signature
      t.datetime :signed_at
      t.float :rate
      t.float :gas
      t.string :tax_name
      t.float :tax_rate
      t.text :client_satisfaction
      t.string :payment_method
      t.float :discount
      t.string :credit_card_type
      t.integer :lock_version, :integer, :default => 0
      t.float :tip
      t.string :furnitures
      t.boolean :too_big_for_stairway
      t.boolean :too_big_for_hallway
      t.boolean :too_big
      t.boolean :broken
      t.boolean :too_fragile
      
      t.timestamps
    end
  end
end
