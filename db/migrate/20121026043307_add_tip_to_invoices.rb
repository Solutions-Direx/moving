class AddTipToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :tip, :float
  end
end
