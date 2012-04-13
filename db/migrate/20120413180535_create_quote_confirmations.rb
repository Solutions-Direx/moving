class CreateQuoteConfirmations < ActiveRecord::Migration
  def change
    create_table :quote_confirmations do |t|
      t.integer :quote_id
      t.integer :user_id
      t.datetime :approved_at
      t.string :payment_method
      t.boolean :franchise_cancellation 
      t.boolean :insurance_limit_enough
      t.float :insurance_increase

      t.timestamps
    end
  end
end
