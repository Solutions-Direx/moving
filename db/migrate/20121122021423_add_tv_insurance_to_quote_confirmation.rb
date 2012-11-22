class AddTvInsuranceToQuoteConfirmation < ActiveRecord::Migration
  def change
    add_column :quote_confirmations, :tv_insurance, :boolean, default: false
    add_column :quote_confirmations, :tv_insurance_price, :float
  end
end