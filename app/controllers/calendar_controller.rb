class CalendarController < ApplicationController
  load_and_authorize_resource
  set_tab :calendar
  
  def show
    @quotes = Quote.all
    @date = params[:month] ? Date.strptime(params[:month], "%Y-%m") : Date.today
  end
end
