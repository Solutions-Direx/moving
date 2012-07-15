class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :invoice_id
      t.float :amount
      t.date :date
      t.string :payment_method
      t.string :credit_card_type
      t.string :transaction_number
      t.integer :creator_id

      t.timestamps
    end
  end
end
