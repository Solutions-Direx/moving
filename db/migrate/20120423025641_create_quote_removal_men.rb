class CreateQuoteRemovalMen < ActiveRecord::Migration
  def change
    create_table :quote_removal_men do |t|
      t.integer :quote_id
      t.integer :removal_man_id

      t.timestamps
    end
  end
end
