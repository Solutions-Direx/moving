class CreateInvoiceForfaits < ActiveRecord::Migration
  def change
    create_table :invoice_forfaits do |t|
      t.integer :invoice_id
      t.integer :forfait_id

      t.timestamps
    end
  end
end
