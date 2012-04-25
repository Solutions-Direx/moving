class QuoteConfirmationObserver <  ActiveRecord::Observer
  
  def after_create(confirmation)
    Removal.create!(quote_id: confirmation.quote_id, 
                    payment_method: confirmation.payment_method,
                    franchise_cancellation: confirmation.franchise_cancellation,
                    insurance_limit_enough: confirmation.insurance_limit_enough,
                    insurance_increase: confirmation.insurance_increase
                   )
  end
  
end