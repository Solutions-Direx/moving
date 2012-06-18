class ReportsController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column
  set_tab :reports
  
  def index
    @invoices = current_account.invoices.includes(:quote).where('invoices.signed_at IS NOT NULL').includes(:quote).order(sort_column + " " + sort_direction).page(params[:page])
  end
  
  def show
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.html { render :layout => false }
      format.js { render :template => 'reports/show', :layout => false, :formats => [:html] }
    end
  end
  
  protected
  
  def sort_column
    params[:sort].present? ? params[:sort] : "signed_at"
  end
  
end
