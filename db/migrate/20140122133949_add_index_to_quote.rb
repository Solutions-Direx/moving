class AddIndexToQuote < ActiveRecord::Migration
  def change
    add_index :quotes, [:status, :removal_at], :name => "quotes_removal_at_index"
  end
end
