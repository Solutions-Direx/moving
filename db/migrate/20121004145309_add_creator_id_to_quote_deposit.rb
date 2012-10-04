class AddCreatorIdToQuoteDeposit < ActiveRecord::Migration
  def change
    add_column :quote_deposits, :creator_id, :integer
  
    QuoteDeposit.all.each do |deposit|
      deposit.creator_id = deposit.quote.creator_id
      deposit.save!
    end
  end
end