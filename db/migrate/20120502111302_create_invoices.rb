class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :code
      t.integer :quote_id
      t.float :time_spent
      t.text :comment
      t.string :signer_name
      t.text :signature
      t.datetime :signed_at
      t.float :rate
      t.float :gas
      t.string :tax1_label
      t.float :tax1
      t.string :tax2_label
      t.float :tax2
      t.boolean :compound
      t.text :client_satisfaction
      t.string :payment_method
      t.string :dicsount
      t.string :credit_card_type
      
      t.timestamps
    end
  end
end
