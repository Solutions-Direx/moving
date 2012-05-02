class InvoicesController < ApplicationController
  # load_and_authorize_resource
  before_filter :load_quote_and_invoice
  set_tab :invoice
  
  def show
  end
  
  def edit
    redirect_to quote_invoice_url(@quote, @invoice) if @invoice.signed?
  end
  
  def update
    @invoice.assign_attributes(params[:invoice])
    @invoice.signed_at = Time.now unless @invoice.signature.blank?
    @invoice.save!
    if request.xhr?
      render :nothing => true
    else
      redirect_to quote_invoice_url(@quote, @invoice), notice: "Invoice signed"
    end  
  end
  
  protected
  
  def load_quote_and_invoice
    @quote = Quote.find(params[:quote_id])
    @invoice = Invoice.find(params[:id])
  end
end
  