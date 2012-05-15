module Mobile
  class DashboardController < BaseController
  
    def show
      set_tab :today
      @quotes = current_account.quotes.confirmed.today.order('removal_at ASC')
    end
  
  end
end