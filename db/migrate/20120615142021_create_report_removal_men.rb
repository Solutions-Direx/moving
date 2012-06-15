class CreateReportRemovalMen < ActiveRecord::Migration
  def change
    create_table :report_removal_men do |t|
      t.integer :report_id
      t.integer :removal_man_id

      t.timestamps
    end
  end
end
