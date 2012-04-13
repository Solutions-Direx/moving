class Forfait < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  belongs_to :account
  
  attr_accessible :account_id, :description, :name, :price
  
  validates_presence_of :name, :description, :price
  validates_uniqueness_of :name
  
  def name_with_price
    "#{name} (#{number_to_currency(price)})"
  end
end
