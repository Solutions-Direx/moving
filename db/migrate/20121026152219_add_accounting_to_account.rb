class AddAccountingToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :accounting_payment_cash_account_number, :string
    add_column :accounts, :accounting_payment_debit_account_number, :string
    add_column :accounts, :accounting_payment_credit_account_number, :string
    add_column :accounts, :accounting_payment_cheque_account_number, :string
  end
end
