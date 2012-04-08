class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :quote_id
      t.string :size
      t.text :comment

      t.timestamps
    end
  end
end
