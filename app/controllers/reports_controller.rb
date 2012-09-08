class ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_quote_and_report, :except => [:index]
  helper_method :sort_column
  set_tab :reports
  
  def index
    # @invoices = current_account.invoices.includes(:quote).where('invoices.signed_at IS NOT NULL').includes(:quote).order(sort_column + " " + sort_direction).page(params[:page])
    @reports = current_account.reports.includes(:quote => :invoice).order(sort_column + " " + sort_direction).page(params[:page])
  end
  
  def quick_view
    respond_to do |format|
      format.html { render :layout => false }
      format.js { render :template => 'reports/quick_view', :layout => false, :formats => [:html] }
    end
  end

  def show
    
  end

  def edit
  end

  def update
    @report.update_attributes(params[:report])
    @is_preview = params[:commit] == "Preview"
  end

  def sign
    @report.assign_attributes(params[:report])
    @report.signed_at = Time.now unless @report.signature.blank?
    @report.save!
    if request.xhr?
      render :nothing => true
    else
      redirect_to quote_report_url(@quote), notice: "#{Report.model_name.human} #{t 'is_signed'}"
    end
  end
  
  protected

  def load_quote_and_report
    @quote = Quote.find_by_code(params[:quote_id])
    @report = @quote.report
  end
  
  def sort_column
    params[:sort].present? ? params[:sort] : "signed_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
end
