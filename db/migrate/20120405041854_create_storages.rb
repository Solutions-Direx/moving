class CreateStorages < ActiveRecord::Migration
  def change
    create_table :storages do |t|
      t.string :name
      t.boolean :internal, :default => false
      t.float :price
      t.integer :account_id

      t.timestamps
    end
  end
end
