class CreateForfaits < ActiveRecord::Migration
  def change
    create_table :forfaits do |t|
      t.string :name
      t.text :description
      t.float :price
      t.integer :account_id

      t.timestamps
    end
  end
end
