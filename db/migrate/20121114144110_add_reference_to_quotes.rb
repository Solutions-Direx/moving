class AddReferenceToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :reference, :string

    Quote.all.each do |quote|
      quote.update_attribute(:updated_at, Time.now)
    end

  end
end
