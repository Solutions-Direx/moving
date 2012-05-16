class Overtime < ActiveRecord::Base
  belongs_to :invoice
  attr_accessible :duration, :invoice_id, :rate
  
  def amount
    ((try(:duration) || 0) * (try(:rate) || 0)).round(2)
  end
end
