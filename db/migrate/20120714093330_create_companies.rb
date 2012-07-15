class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :account_id
      t.string :company_name
      t.string :phone
      t.string :website
      t.string :email
      t.has_attached_file :logo
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
