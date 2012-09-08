class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :actor_id
      t.integer :quote_id
      t.string :action
      t.references :trackable, :polymorphic => true

      t.timestamps
    end
  end
end
