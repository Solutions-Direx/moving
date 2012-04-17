class CalendarController < ApplicationController
  load_and_authorize_resource
  set_tab :calendar
  
  def show
    @quotes = Quote.all
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
  end
end
