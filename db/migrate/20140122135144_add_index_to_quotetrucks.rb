class AddIndexToQuotetrucks < ActiveRecord::Migration
  def change
    add_index :quote_trucks, :quote_id, :name => "quote_trucks_quote_id_index"
    add_index :quote_trucks, :truck_id, :name => "quote_trucks_truck_id_index"
  end
end
