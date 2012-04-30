class RemovalsController < ApplicationController
  load_and_authorize_resource
  
  def update
    quote = Quote.find(params[:quote_id])
    removal = Removal.find(params[:id])
    removal.assign_attributes(params[:removal])
    removal.signed_at = Time.now unless removal.signature.blank?
    removal.save!
    redirect_to new_invoice_url, :notice => "Quote successfully approved."
  end
  
end