class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :code
      t.integer :removal_id
      t.integer :quote_id
      t.float :time_spent
      t.text :comment
      t.string :signer_name
      t.text :signature
      t.datetime :signed_at
      t.float :rate
      t.float :overtime_rate
      t.float :overtime
      t.float :gas
      t.string :tax1_label
      t.float :tax1
      t.string :tax2_label
      t.float :tax2
      t.boolean :compound
      t.text :client_satisfaction
      t.string :payment_method
      t.boolean :franchise_cancellation 
      t.boolean :insurance_limit_enough
      t.float :insurance_increase

      t.timestamps
    end
  end
end
