class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :set_locale
  before_filter :set_ajax
  helper_method :current_account, :sort_direction
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  def current_account
    @current_account ||= Account.first
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
private
  
  def set_locale
    if user_signed_in? && current_user.localization.present?
      I18n.locale = current_user.localization 
    end
  end
  
  def set_ajax
    @ajax = request.xhr?
  end
end
