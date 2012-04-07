class CreateSupplies < ActiveRecord::Migration
  def change
    create_table :supplies do |t|
      t.string :name
      t.boolean :active, :default => true
      t.float :price
      t.integer :account_id

      t.timestamps
    end
  end
end
