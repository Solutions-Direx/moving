class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.integer :account_id
      t.integer :client_id
      t.datetime :removal_at
      t.datetime :date
      t.boolean :is_house
      t.integer :nb_appliance
      t.integer :num_of_removal_man
      t.float :price
      t.float :gas
      t.datetime :transport_at
      t.boolean :insurance
      t.integer :rating
      t.integer :creator_id

      t.timestamps
    end
  end
end
