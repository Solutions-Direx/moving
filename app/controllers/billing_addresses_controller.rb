class BillingAddressesController < ApplicationController
  before_filter :load_quote

  def edit
  end

  def update
    if @billing_address.update_attributes(params[:quote_billing_address])
      if request.xhr?
        render partial: "flash_modal_msg", locals: { message: "#{t('billing_address')} #{t('is_updated')}.", close_dialog_id: "edit-billing-address" }
      else
        redirect_to @quote, notice: "Quote #{t 'is_updated'}"
      end
    else
      render action: "edit", layout: !request.xhr?
    end
  end

  private

    def load_quote
      @quote = Quote.find_by_code(params[:quote_id])
      @billing_address = @quote.billing_address
    end
end