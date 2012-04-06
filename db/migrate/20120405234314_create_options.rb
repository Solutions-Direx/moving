class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :name
      t.boolean :active, :default => true
      t.float :price
      t.integer :account_id

      t.timestamps
    end
  end
end
