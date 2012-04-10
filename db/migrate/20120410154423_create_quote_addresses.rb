class CreateQuoteAddresses < ActiveRecord::Migration
  def change
    create_table :quote_addresses do |t|
      t.integer :quote_id
      t.string :type

      t.timestamps
    end
  end
end
