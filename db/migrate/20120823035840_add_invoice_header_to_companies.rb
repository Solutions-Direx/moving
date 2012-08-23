class AddInvoiceHeaderToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :invoice_header, :string
  end
end
