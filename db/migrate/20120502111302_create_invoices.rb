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
      t.float :overtime
      t.float :gas
      t.string :tax1_label
      t.float :tax1
      t.string :tax2_label
      t.float :tax2
      t.boolean :compound

      t.timestamps
    end
  end
end
