class CreateRemovals < ActiveRecord::Migration
  def change
    create_table :removals do |t|
      t.integer :quote_id
      t.string :payment_method
      t.boolean :franchise_cancellation
      t.boolean :insurance_limit_enough
      t.float :insurance_increase
      t.text :signature

      t.timestamps
    end
  end
end
