class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :phone1
      t.string :phone2
      t.string :email
      t.integer :account_id

      t.timestamps
    end
    
    add_index :clients, :phone1
    add_index :clients, :phone2
  end
end
