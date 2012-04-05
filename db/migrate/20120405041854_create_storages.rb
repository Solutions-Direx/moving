class CreateStorages < ActiveRecord::Migration
  def change
    create_table :storages do |t|
      t.string :name
      t.boolean :default, :default => false
      t.string :account_id

      t.timestamps
    end
  end
end
