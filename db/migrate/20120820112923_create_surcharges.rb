class CreateSurcharges < ActiveRecord::Migration
  def change
    create_table :surcharges do |t|
      t.references :surchargeable, :polymorphic => true
      t.string :label
      t.float :price

      t.timestamps

    end
    drop_table :overtimes

  end
end
