class CreateOvertimes < ActiveRecord::Migration
  def change
    create_table :overtimes do |t|
      t.integer :invoice_id
      t.float :duration
      t.float :rate

      t.timestamps
    end
  end
end
