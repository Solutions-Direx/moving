class CreateTrucks < ActiveRecord::Migration
  def change
    create_table :trucks do |t|
      t.string :name
      t.string :plate
      t.integer :account_id

      t.timestamps
    end
  end
end
