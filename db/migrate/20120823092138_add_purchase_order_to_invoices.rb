class AddPurchaseOrderToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :purchase_order, :string
  end
end
