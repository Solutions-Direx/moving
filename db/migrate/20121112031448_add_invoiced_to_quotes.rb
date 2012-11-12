class AddInvoicedToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :invoiced, :boolean, :default => false

    Invoice.all.each do |invoice|
      invoice.quote.update_attribute(:invoiced, true)
    end
  end
end
