class ReportsController < ApplicationController
  # load_and_authorize_resource
  before_filter :load_quote_and_report, :except => ['index', :export]
  set_tab :report
  
  def index
    @reports = current_account.reports.order(sort_column + " " + sort_direction).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quotes }
    end
  end
  
  def show
    session[:current_view] = "invoice"
  end
  
  def edit
    session[:current_view] = "report"
    redirect_to quote_report_url(@quote) if @report.signed?
  end
  
  def sign
    @report.assign_attributes(params[:report])
    @report.signed_at = Time.now unless @report.signature.blank?
    @report.save!
    if request.xhr?
      render :nothing => true
    else
      redirect_to quote_report_url(@quote), notice: "#{Report.model_name.human} #{t 'signed'}"
    end
  end
  
  def update
    @report.update_attributes(params[:report])
    @is_preview = params[:commit] == "Preview"
  end
  
  def export
    @reports = current_account.reports
    
    respond_to do |format|
      format.csv
    end
  end
  
protected
  
  def load_quote_and_report
    @quote = Quote.find(params[:quote_id])
    @report = @quote.report
  end
  
  def sort_column
    Invoice.column_names.include?(params[:sort]) ? params[:sort] : "signed_at"
  end
end
