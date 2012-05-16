class DashboardController < ApplicationController
  
  def show
    @quotes = current_account.quotes.confirmed.today.order('removal_at ASC')
    redirect_to mobile_root_url if current_user.removal_man?
  end
  
  def search
    @results = PgSearch.multisearch(params[:query]).page(params[:page] || 1).per(20)
  end
end