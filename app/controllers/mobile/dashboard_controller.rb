module Mobile
  class DashboardController < BaseController
  
    def show
      set_tab :today
      @quotes = current_account.quotes.confirmed.today.where(removal_leader_id: current_user.id).order('removal_at ASC')
    end
  
  end
end