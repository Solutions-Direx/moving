class CreateQuoteDeposits < ActiveRecord::Migration
  def change
    create_table :quote_deposits do |t|
      t.integer :quote_id
      t.float :amount
      t.date :date
      t.string :payment_method
      t.string :credit_card_type

      t.timestamps
    end
  end
end
