class CreateQuoteDailyTrucks < ActiveRecord::Migration
  def change
    create_table :quote_daily_trucks do |t|
      t.integer :quote_id
      t.integer :truck_id

      t.timestamps
    end
  end
end
