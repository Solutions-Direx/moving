class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :company_name
      t.string :logo
      t.string :phone
      t.string :website
      t.string :email
      t.float :franchise_cancellation_amount
      t.float :insurance_coverage_short_distance
      t.float :insurance_coverage_long_distance
      t.integer :invoice_start_number
      t.boolean :rebase_invoice_number, :default => false
      t.has_attached_file :logo

      t.timestamps
    end
  end
end
