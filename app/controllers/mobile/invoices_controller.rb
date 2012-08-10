module Mobile
  class InvoicesController < BaseController
    # load_and_authorize_resource
    before_filter :load_quote_and_invoice, :except => [:index, :new, :create]
    set_tab :invoice
  
    def show
      session[:current_view] = "invoice"
    end
  
    def edit
      session[:current_view] = "invoice"
      redirect_to mobile_quote_invoice_url(@quote) if @invoice.signed?
    end
  
    def sign
      @invoice.assign_attributes(params[:invoice])
      @invoice.signed_at = Time.now unless @invoice.signature.blank?
      @invoice.save!
      if request.xhr?
        render :nothing => true
      else
        redirect_to mobile_quote_invoice_url(@quote), notice: "#{Invoice.model_name.human} #{t 'signed'}"
      end
    end
  
    def update
      @invoice.update_attributes(params[:invoice])
      @is_preview = params[:commit] == "Preview"
    end
    
    def email
      Mailer.invoice_email(@invoice).deliver
      respond_to do |format|
        format.html { redirect_to mobile_quote_invoice_url(@quote), notice: "#{t 'email_notification', default: "Invoice was successfully sent to "} #{@quote.client.email}" }
        format.json { render json: @invoice }
      end
    end
  
  protected
  
    def load_quote_and_invoice
      @quote = Quote.find_by_code(params[:quote_id])
      @invoice = @quote.invoice
    end
  
    def sort_column
      Invoice.column_names.include?(params[:sort]) ? params[:sort] : "signed_at"
    end
    
    def correct_stale_record_version
      @quote.reload
      @invoice.reload
      @invoice.errors.add(:base, t('conflict', default: "Conflict"))
    end
  end
end