class RemovalsController < ApplicationController
  load_and_authorize_resource
  
  def update
    quote = Quote.find(params[:quote_id])
    removal = Removal.find(params[:id])
    removal.update_attributes(params[:removal])
    redirect_to new_invoice_url, :notice => "Removal successfully updated."
  end
  
  def sign
    quote = Quote.find(params[:quote_id])
    removal = Removal.find(params[:id])
    removal.assign_attributes(params[:removal])
    removal.signed_at = Time.now unless removal.signature.blank?
    removal.save!
    invoice = removal.create_invoice(quote_id: removal.quote_id)
    
    redirect_to edit_quote_invoice_url(quote, invoice), :notice => "Quote successfully approved."
  end
  
end