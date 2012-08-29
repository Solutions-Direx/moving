class RemoveTipFromInvoices < ActiveRecord::Migration
  def up
    remove_column :invoices, :tip
  end

  def down
    add_column :invoices, :tip, :float
  end
end
