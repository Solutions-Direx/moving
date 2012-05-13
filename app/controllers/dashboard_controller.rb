class DashboardController < ApplicationController
  
  def show
    authorize! :read, :dashboard
    set_tab :today
    @quotes = current_account.quotes.confirmed.today.order('removal_at ASC')
    render layout: current_user.removal_man? ? 'mobile' : 'application'
  end
end
