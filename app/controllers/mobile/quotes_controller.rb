module Mobile
  class QuotesController < BaseController
    before_filter :load_quote
    
    def terms
      session[:current_view] = "terms"
      set_tab :terms

      respond_to do |format|
        format.html
        format.json { render json: @quote }
      end
    end

    def sign
      authorize! :sign, @quote
      @quote.assign_attributes(params[:quote])
      @quote.signed_at = Time.now unless @quote.signature.blank?
      if @quote.save
        if @quote.invoice.blank?
          invoice = @quote.build_invoice(payment_method: @quote.quote_confirmation.payment_method) 
          invoice.copy_quote_info
          invoice.client_id = @quote.client_id
          invoice.save!
        end
        @quote.create_report!(gas: @quote.gas, start_time: @quote.removal_at) if @quote.report.blank?
        redirect_to terms_mobile_quote_url(@quote), notice: "#{Quote.model_name.human} #{t 'signed'}"
      else
        redirect_to terms_mobile_quote_url(@quote), alert: "#{Quote.model_name.human} #{t 'cannot_be_saved'}"
      end
    end
    
private

    def load_quote
      @quote = Quote.find(params[:id])
    end
      
    def correct_stale_record_version
      @quote.reload
    end
  end
end