class ChangeLabelSurchargeColumnType < ActiveRecord::Migration
  def change
  	change_column :surcharges, :label, :text
  end
end