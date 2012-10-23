class RemoveTipFromPayments < ActiveRecord::Migration
  def up
    remove_column :payments, :tip
  end

  def down
    add_column :payments, :tip, :string
  end
end
