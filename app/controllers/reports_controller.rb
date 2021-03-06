class ReportsController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!
  before_filter :load_quote_and_report, :except => [:index, :payments, :stats]
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
  
  # Payments report
  def payments
    if params[:day].present?
      @day = Date.strptime(params[:day].to_s, I18n.t('date.formats.default'))
      @payments = Payment.includes(:payable => :client).where("payable_type in (?,?)", "Invoice", "Quote").by_day(@day).order(sort_column + " " + sort_direction).page(params[:page])
      @total = Payment.includes(:payable => :client).where("payable_type in (?,?)", "Invoice", "Quote").by_day(@day).sum('amount')
    else
      @day = Time.zone.today
      @payments = Payment.includes(:payable => :client).where("payable_type in (?,?)", "Invoice", "Quote").today.order(sort_column + " " + sort_direction).page(params[:page])
      @total = Payment.includes(:payable => :client).where("payable_type in (?,?)", "Invoice", "Quote").today.sum('amount')
    end

    respond_to do |format|
      format.html
    end
  end
  
  def verify
    @report.verify_report
    
    respond_to do |format|
      if @report.update_attributes(params[:report])
        format.html { redirect_to quote_report_url(@quote), notice: "#{Report.model_name.human} #{t 'is_verified'}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def stats
    if params[:searching].present?
      @invoices = Invoice.joins(:quote, :client).page(params[:page]).order(sort_column + " " + sort_direction)
      @invoices = @invoices.where('clients.commercial = ?', params[:client_type]) if params[:client_type].present?
      if params[:from].present? && params[:to].present?
        @invoices = @invoices.where('quotes.removal_at' => (params[:from].to_date..params[:to].to_date))
      elsif params[:from].present?
        @invoices = @invoices.where('quotes.removal_at >= ?', params[:from].to_date)
      elsif params[:to].present?
        @invoices = @invoices.where('quotes.removal_at <= ?', params[:to].to_date)
      end
      @invoices = @invoices.where('quotes.sale_representative_id = ?', params[:sale_representative_id]) if params[:sale_representative_id].present?
    end
  end
  
protected

  def load_quote_and_report
    @quote = Quote.find_by_code(params[:quote_id])
    @report = @quote.report
  end
  
  def sort_column
    params[:sort].present? ? params[:sort] : "date"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
end