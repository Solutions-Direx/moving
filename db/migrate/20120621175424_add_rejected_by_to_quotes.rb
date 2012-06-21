class AddRejectedByToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :rejected_by, :integer
    add_column :quotes, :rejected_at, :datetime
  end
end
