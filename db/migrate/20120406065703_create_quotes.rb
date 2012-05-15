class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.integer :code
      t.integer :account_id
      t.integer :client_id
      t.string :phone1
      t.string :phone2
      t.datetime :removal_at
      t.string :removal_at_comment
      t.datetime :date
      t.boolean :is_house, :default => true
      t.boolean :materiel
      t.integer :num_of_removal_man
      t.float :price
      t.float :gas
      t.string :transport_time
      t.boolean :insurance
      t.string :rating, :default => "A"
      t.integer :creator_id
      t.string :status, :default => "Pending"
      t.text :comment
      t.boolean :pm, :default => false
      t.boolean :long_distance, :default => false
      t.integer :removal_leader_id
      t.boolean :internal_address, :default => false
      t.string :signer_name
      t.text :signature
      t.datetime :signed_at
      t.integer :lock_version, :integer, :default => 0

      t.timestamps
    end
  end
end
