class PaymentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_filter :load_quote_and_invoice

  def index
    @payments = @invoice.payments.order("date DESC")
  end

  def new
    @payment = @invoice.payments.build  
  end

  def create
    @payment = @invoice.payments.build(params[:payment])
    @payment.creator = current_user

    respond_to do |format|
      if @payment.save
        format.html { redirect_to quote_invoice_payments_url(@quote), notice: "#{Payment.model_name.human} #{t 'is_created'}" }
        format.json { render json: @payment, status: :created, location: @truck }
      else
        format.html { render action: "new" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @payment = Payment.find(params[:id])
  end

  def update
    @payment = Payment.find(params[:id])

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to quote_invoice_payments_url(@quote), notice: "#{Payment.model_name.human} #{t 'is_updated'}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to quote_invoice_payments_url(@quote), notice: "#{Payment.model_name.human} #{t 'is_deleted'}" }
      format.json { head :no_content }
    end
  end

  private

  def load_quote_and_invoice
    @quote = Quote.find(params[:quote_id])
    @invoice = @quote.invoice
  end
end