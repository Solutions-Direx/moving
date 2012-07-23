class AddPriceToQuoteAddress < ActiveRecord::Migration
  def change
    add_column :quote_addresses, :price, :float
  end
end
