class CreateSurcharges < ActiveRecord::Migration
  def change
    create_table :surcharges do |t|
      t.integer :invoice_id
      t.string :label
      t.float :price

      t.timestamps

    end
    drop_table :overtimes

  end
end
