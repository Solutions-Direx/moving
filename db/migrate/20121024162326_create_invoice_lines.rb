class CreateInvoiceLines < ActiveRecord::Migration
  def change
    create_table :invoice_lines do |t|
    	t.string  :item_name
    	t.integer :quantity
      t.float   :amount
      t.integer :invoice_id
      t.string  :invoiceable_type
      t.integer :invoiceable_id

      t.timestamps
    end
  end
end