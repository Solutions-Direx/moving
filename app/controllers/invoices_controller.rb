# encoding: utf-8
require 'iconv'

class InvoicesController < ApplicationController
  # load_and_authorize_resource
  before_filter :load_quote_and_invoice, :except => [:index, :export, :reports, :new, :create]
  helper_method :sort_column
  set_tab :invoices
  
  def index
    if params[:search].present?
      query = params[:search].gsub(".", " ")
      @invoices = current_account.invoices.includes({:quote => [:client, :quote_confirmation, {:to_addresses => [:storage]}]}, :forfaits, :surcharges, :supplies).search_by_keyword(query).page(params[:page])
    else
      @invoices = current_account.invoices.includes({:quote => [:client, :quote_confirmation]}, :forfaits, :surcharges, :supplies).order(sort_column + " " + sort_direction).page(params[:page])
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
    @invoice.creator_id = current_user.id
    if @invoice.save
      redirect_to quote_invoice_url(@quote), notice: "#{Invoice.model_name.human} #{t 'created'}."
    else
      render action: :new
    end
  end
  
  def show
    #@quote = Quote.find_by_code(params[:quote_id])
    #@invoice = @quote.invoice.includes(:lines)
    @payments = @invoice.payments.order("date ASC")
  end
  
  def edit
    redirect_to quote_invoice_url(@quote) if @invoice.signed?
  end
  
  def email
    Mailer.invoice_email(@invoice).deliver
    respond_to do |format|
      format.html { redirect_to quote_invoice_url(@quote), notice: "#{t 'invoice_email_notification', default: "Invoice was successfully sent to "} #{@quote.client.email}" }
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

    respond_to do |format|
      format.csv { 
        content = Invoice.export(current_account, params[:quotes])
        content = Iconv.conv('ISO-8859-1','UTF-8', content)
        send_data content, 
          :filename => "invoices.csv", 
          :type => 'text/csv; charset=utf-8; header=present',
          :disposition => "attachment"
      }
    end
  end
  
  def print
    respond_to do |format|
      format.html
      # format.pdf { render :text => PDFKit.new(render_to_string(:formats => [:html], :layout => 'print')).to_pdf }
      format.pdf do
        pdf = InvoicePdf.new(@invoice)
        send_data pdf.render, filename: "invoice_#{@invoice.code}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
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

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
  def correct_stale_record_version
    @quote.reload
    @invoice.reload
    @invoice.errors.add(:base, t('conflict'))
  end
end