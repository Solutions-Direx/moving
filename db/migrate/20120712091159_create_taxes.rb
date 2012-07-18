class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.integer :account_id
      t.string :province
      t.string :tax1_label
      t.float :tax1
      t.string :tax2_label
      t.float :tax2
      t.boolean :compound
      t.boolean :is_default, :default => false

      t.timestamps
    end
  end
end
