class CreateAnnexes < ActiveRecord::Migration
  def change
    create_table :annexes do |t|
      t.string :name
      t.text :body
      t.integer :storage_id

      t.timestamps
    end
  end
end
