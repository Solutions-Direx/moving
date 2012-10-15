class MakePaymentPolymorphic < ActiveRecord::Migration
  def up
    add_column :payments, :payable_id, :integer
    add_column :payments, :payable_type, :string

    Payment.all.each do |payment|
      payment.payable = Invoice.find(payment.invoice_id)
      payment.save!
    end
    remove_column :payments, :invoice_id

    Payment.reset_column_information

    QuoteDeposit.all.each do |deposit|
      payment = Payment.new
      payment.payable = Quote.find(deposit.quote_id)
      payment.payment_method = deposit.payment_method
      payment.credit_card_type = deposit.credit_card_type
      payment.date = deposit.date
      payment.amount = deposit.amount
      payment.save!
    end

    drop_table :quote_deposits
  end

  def down
  end
end
