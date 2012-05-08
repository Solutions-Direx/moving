class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :removal_id
      t.integer :quote_id
      t.float :time_spent
      t.text :comment
      t.string :signer_name
      t.text :signature
      t.datetime :signed_at
      t.float :rate
      t.float :overtime_rate
      t.integer :num_of_overtime_men
      t.float :gas

      t.timestamps
    end
  end
end
