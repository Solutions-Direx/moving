class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :account_id
      t.string :name
      t.text :body

      t.timestamps
    end
  end
end
