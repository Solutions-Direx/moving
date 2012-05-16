class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :quote_id
      t.float :km_start
      t.float :km_end
      t.float :gas
      t.datetime :start_time
      t.datetime :end_time
      t.float :distance_in_qc
      t.float :distance_in_on
      t.float :distance_in_nb
      t.float :distance_other
      t.string :signer_name
      t.text :signature
      t.datetime :signed_at
      t.text :comment

      t.timestamps
    end
  end
end
