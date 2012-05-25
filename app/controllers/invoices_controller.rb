class InvoicesController < ApplicationController
  # load_and_authorize_resource
  before_filter :load_quote_and_invoice, :except => [:index, :export, :reports, :new, :create]
  set_tab :invoices
  
  def index
    @invoices = current_account.invoices.includes(:quote).order(sort_column + " " + sort_direction).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quotes }
    end
  end
  
  def new
    @quote = Quote.find(params[:quote_id])
    @invoice = @quote.build_invoice(payment_method: @quote.quote_confirmation.payment_method)
    @invoice.copy_quote_info
  end
  
  def create
    @quote = Quote.find(params[:quote_id])
    @invoice = @quote.build_invoice(params[:invoice])
    @invoice.copy_tax_setting_from(@quote.account)
    if @invoice.save
      redirect_to quote_invoice_url(@quote), notice: "Invoice successfully created."
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
      redirect_to quote_invoice_url(@quote), notice: "Invoice successfully updated."
    else
      render action: :edit
    end
  end
  
  def export
    @invoices = current_account.invoices
    
    respond_to do |format|
      format.csv
    end
  end
  
  def reports
    set_tab :reports
    @invoices = current_account.invoices.where('invoices.signed_at IS NOT NULL').includes(:quote).order(sort_column + " " + sort_direction).page(params[:page])
  end
  
  def print
    respond_to do |format|
      format.html
      format.pdf { render :text => PDFKit.new(render_to_string(:formats => [:html], :layout => 'print')).to_pdf }
    end
  end
  
protected
  
  def load_quote_and_invoice
    @quote = Quote.find(params[:quote_id])
    @invoice = @quote.invoice
  end
  
  def sort_column
    Invoice.column_names.include?(params[:sort]) ? params[:sort] : "signed_at"
  end
  
  def correct_stale_record_version
    @quote.reload
    @invoice.reload
    # @invoice.errors.add(:base, t('conflict', default: "Another user has made a change to this record since you access the edit form. Please recheck information and update again."))
  end
end
  