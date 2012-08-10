class InvoicesController < ApplicationController
  # load_and_authorize_resource
  before_filter :load_quote_and_invoice, :except => [:index, :export, :reports, :new, :create]
  helper_method :sort_column
  set_tab :invoices
  
  def index
    if params[:search].present?
      @invoices = current_account.invoices.includes({:quote => [:client, :quote_confirmation, {:to_addresses => [:storage]}]}, :forfaits, :overtimes, :supplies).search_by_keyword(params[:search]).page(params[:page])
    else
      @invoices = current_account.invoices.includes({:quote => [:client, :quote_confirmation]}, :forfaits, :overtimes, :supplies).order(sort_column + " " + sort_direction).page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quotes }
    end
  end
  
  def new
    @quote = Quote.find_by_code(params[:quote_id])
    @invoice = @quote.build_invoice(payment_method: @quote.quote_confirmation.payment_method)
    @invoice.copy_quote_info
  end
  
  def create
    @quote = Quote.find_by_code(params[:quote_id])
    @invoice = @quote.build_invoice(params[:invoice])

    @invoice.copy_tax_setting_from(@quote.tax)
    @invoice.client_id = @quote.client_id
    if @invoice.save
      redirect_to quote_invoice_url(@quote), notice: "#{Invoice.model_name.human} #{t 'created'}."
    else
      render action: :new
    end
  end
  
  def show
  end
  
  def edit
    redirect_to quote_invoice_url(@quote) if @invoice.signed?
  end
  
  def email
    Mailer.invoice_email(@invoice).deliver
    respond_to do |format|
      format.html { redirect_to quote_invoice_url(@quote), notice: "#{t 'email_notification', default: "Invoice was successfully sent to "} #{@quote.client.email}" }
      format.json { render json: @invoice }
    end
  end
  
  def update
    if @invoice.update_attributes(params[:invoice])
      redirect_to quote_invoice_url(@quote), notice: "#{Invoice.model_name.human} #{t 'updated'}"
    else
      render action: :edit
    end
  end
  
  def export
    @invoices = current_account.invoices.includes({:quote => [:client, :quote_confirmation, :deposit]}, :forfaits, :overtimes, :supplies)
    if params[:invoices].present?
      @invoices = @invoices.where(id: params[:invoices])
    end
    
    respond_to do |format|
      format.csv
    end
  end
  
  def print
    respond_to do |format|
      format.html
      format.pdf { render :text => PDFKit.new(render_to_string(:formats => [:html], :layout => 'print')).to_pdf }
    end
  end
  
  def sign
    @invoice.assign_attributes(params[:invoice])
    @invoice.signed_at = Time.now unless @invoice.signature.blank?
    @invoice.save!
    if request.xhr?
      render :nothing => true
    else
      redirect_to quote_invoice_url(@quote), notice: "#{Invoice.model_name.human} #{t 'signed'}"
    end
  end
  
protected
  
  def load_quote_and_invoice
    @quote = Quote.find_by_code(params[:quote_id])
    @invoice = @quote.invoice
  end
  
  def sort_column
    params[:sort].present? ? params[:sort] : "signed_at"
  end
  
  def correct_stale_record_version
    @quote.reload
    @invoice.reload
    @invoice.errors.add(:base, t('conflict'))
  end
end