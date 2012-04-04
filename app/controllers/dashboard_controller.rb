class DashboardController < ApplicationController
  def show
    authorize! :read, :dashboard
  end
end
