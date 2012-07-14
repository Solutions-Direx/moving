class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.integer :account_id
      t.string :province
      t.string :tax_name
      t.float :tax_rate
      t.boolean :is_default, :default => false

      t.timestamps
    end
  end
end
