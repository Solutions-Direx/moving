class AuditController < ApplicationController
  # load_and_authorize_resource
  helper_method :sort_column
  
  def index
    @activities = Activity.all
  end
  
protected

  def sort_column
    params[:sort].present? ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end