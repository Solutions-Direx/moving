class CreateQuoteForfaits < ActiveRecord::Migration
  def change
    create_table :quote_forfaits do |t|
      t.integer :quote_id
      t.integer :forfait_id

      t.timestamps
    end
  end
end
