class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :company_name
      t.string :logo
      t.string :tax1_label
      t.float :tax1
      t.string :tax2_label
      t.float :tax2
      t.boolean :compound
      t.string :phone
      t.string :website
      t.string :email

      t.timestamps
    end
  end
end
