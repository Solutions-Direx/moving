class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :define_current_user
  before_filter :authenticate_user!
  before_filter :set_locale
  before_filter :set_ajax
  helper_method :current_account, :sort_direction
  layout :set_layout
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => t('you_are_not_authorized_to_access_this_page', default: 'You are not authorized to access this page.')
  end
  
  rescue_from ActiveRecord::StaleObjectError do |exception|
    respond_to do |format|
      format.html {
        correct_stale_record_version
        stale_record_recovery_action
      }
      format.xml  { head :conflict }
      format.json { head :conflict }
      format.js
    end
  end     

  def define_current_user
    User.current_user = current_user
  end
  
  def current_account
    @current_account ||= Account.first
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
  def set_layout
    (current_user && current_user.removal_man?) ? 'mobile' : 'application' 
  end
  
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || (resource.removal_man? ? m_root_path : root_path)
  end
  
protected   
  
  def stale_record_recovery_action
    flash.now[:alert] = t('conflict', default: "Another user made a change to this record since you accessed the edit form. Please check information and update again.")
    render :edit, :status => :conflict
  end
  
  def set_locale
    if user_signed_in? && current_user.localization.present?
      I18n.locale = current_user.localization 
    end
  end
  
  def set_ajax
    @ajax = request.xhr?
  end
end