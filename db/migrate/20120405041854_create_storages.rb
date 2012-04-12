class CreateStorages < ActiveRecord::Migration
  def change
    create_table :storages do |t|
      t.string :name
      t.boolean :internal, :default => false
      t.float :price
      t.string :account_id

      t.timestamps
    end
  end
end
