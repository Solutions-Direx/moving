class AddSaleRepresentativeIdToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :sale_representative_id, :integer

    Quote.all.each do |quote|
      quote.sale_representative_id = quote.creator_id
      quote.save(validate: false)
    end
  end
end
