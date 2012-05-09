class InvoicesController < ApplicationController
  # load_and_authorize_resource
  before_filter :load_quote_and_invoice, :except => ['index', :export]
  set_tab :invoices
  
  def index
    @invoices = current_account.invoices.order(sort_column + " " + sort_direction).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quotes }
    end
  end
  
  def show
  end
  
  def edit
    redirect_to quote_invoice_url(@quote, @invoice) if @invoice.signed?
  end
  
  def sign
    @invoice.assign_attributes(params[:invoice])
    @invoice.signed_at = Time.now unless @invoice.signature.blank?
    @invoice.save!
    if request.xhr?
      render :nothing => true
    else
      redirect_to quote_invoice_url(@quote, @invoice), notice: "#{Invoice.model_name.human} #{t 'signed'}"
    end
  end
  
  def update
    @invoice.update_attributes(params[:invoice])
    @is_preview = params[:commit] == "Preview"
  end
  
  def export
    @invoices = current_account.invoices
    
    respond_to do |format|
      format.csv
    end
  end
  
protected
  
  def load_quote_and_invoice
    @quote = Quote.find(params[:quote_id])
    @invoice = Invoice.find(params[:id])
  end
  
  def sort_column
    Invoice.column_names.include?(params[:sort]) ? params[:sort] : "signed_at"
  end
end
  