class AddAccountToUser < ActiveRecord::Migration
  def change
    add_column :users, :account_id, :integer
    add_column :users, :role, :string
    add_column :users, :account_owner, :boolean, :default => false
    add_column :users, :localization, :string, :default => "fr"
  end
end
