class AddAccountingToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :accounting_moving_account_number, :string
    add_column :accounts, :accounting_tip_account_number, :string
    add_column :accounts, :accounting_insurance_account_number, :string
    add_column :accounts, :accounting_supply_account_number, :string
  end
end