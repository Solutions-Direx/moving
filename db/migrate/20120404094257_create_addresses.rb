class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :city
      t.string :province
      t.string :postal_code
      t.string :country
      t.integer :addressable_id
      t.string :addressable_type

      t.timestamps
    end
    
    add_index :addresses, :addressable_id
    add_index :addresses, :addressable_type
  end
end
