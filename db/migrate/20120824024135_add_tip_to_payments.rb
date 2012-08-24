class AddTipToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :tip, :float
  end
end
