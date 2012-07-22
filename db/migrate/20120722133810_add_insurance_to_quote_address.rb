class AddInsuranceToQuoteAddress < ActiveRecord::Migration
  def change
    add_column :quote_addresses, :insurance, :float
  end
end
