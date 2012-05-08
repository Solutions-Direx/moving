class CreateInvoiceSupplies < ActiveRecord::Migration
  def change
    create_table :invoice_supplies do |t|
      t.integer :invoice_id
      t.integer :supply_id
      t.integer :quantity

      t.timestamps
    end
  end
end
