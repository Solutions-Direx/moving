class DashboardController < ApplicationController
  def show
    authorize! :read, :dashboard
    @quotes = Quote.today.order('removal_at DESC')
  end
end
