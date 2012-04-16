class CreateQuoteSupplies < ActiveRecord::Migration
  def change
    create_table :quote_supplies do |t|
      t.integer :quote_id
      t.integer :supply_id
      t.integer :quantity

      t.timestamps
    end
  end
end
