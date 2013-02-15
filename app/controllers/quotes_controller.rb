# encoding: utf-8
require 'iconv'

class QuotesController < ApplicationController
  before_filter :load_quote, :only => [:show, :edit, :update, :destroy, :daily_update, :terms, :reject, :sign, :print]
  load_and_authorize_resource
  helper_method :sort_column
  set_tab :quotes
  
  def index
    if params[:search].present?
      query = params[:search].gsub(".", " ")
      @quotes = current_account.quotes.order("created_at DESC").includes(:client, :creator, :company).search_by_keyword(query).page(params[:page])
    else
      @quotes = current_account.quotes.includes(:client, :creator, :company).order(sort_column + " " + sort_direction).page(params[:page])
    end

    if params[:from].present? && params[:to].present?
      @quotes = @quotes.within_period(params[:from].to_date, params[:to].to_date)
    elsif params[:from].present?
      @quotes = @quotes.from_date(Time.zone.parse(params[:from]))
    elsif params[:to].present?
      @quotes = @quotes.to_date(Time.zone.parse(params[:to]))
    end

    if params[:confirmed] == '1'
      @quotes = @quotes.confirmed
    end
    if params[:confirmed] == '0'
      @quotes = @quotes.pending
    end

    if params[:invoiced] == '1'
      @quotes = @quotes.invoiced
    end
    if params[:invoiced] == '0'
      @quotes = @quotes.not_invoiced
    end

    if params[:commercial] == '1'
      @quotes = @quotes.joins(:client).where('clients.commercial = ?', true)
    end
    if params[:commercial] == '0'
      @quotes = @quotes.joins(:client).where('clients.commercial = ?', false)
    end

    @quotes = @quotes.where('quotes.sale_representative_id = ?', params[:sale_representative_id]) if params[:sale_representative_id].present?

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quotes }
      format.pdf do
        pdf = QuotesPdf.new(@quotes)
        send_data pdf.render, filename: "#{t 'quotes_list', default: 'Quotes list'}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quote }
    end
  end

  def new
    @quote = Quote.new
    3.times { @quote.rooms.build }
    @quote.build_from_address.build_address
    @quote.to_addresses.build.build_address
    @quote.client_id = params[:client_id]
    @quote.documents = Document.default
    @quote.sale_representative_id = current_user.id

    companies = current_account.companies.active
    @quote.company_id = companies.first.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quote }
    end
  end

  def edit
    if @quote.invoice.present? && @quote.invoice.signed?
      
      respond_to do |format|
        format.html { redirect_to @quote, alert: "#{Quote.model_name.human} #{t 'can_no_longer_be_edited'}" }
      end
    end
  end

  def create
    @quote = current_account.quotes.new(params[:quote])
    @quote.bypass_validations
    @quote.creator = current_user
    @quote.date = Time.now

    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote }
        format.json { render json: @quote, status: :created, location: @quote }
      else
        format.html { render action: "new" }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @quote.assign_attributes(params[:quote])
    @quote.bypass_validations

    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: "#{Quote.model_name.human} #{t 'updated'}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @quote.destroy

    respond_to do |format|
      format.html { redirect_to quotes_url }
      format.json { head :no_content }
    end
  end
  
  def monthly
    set_tab :calendar
    @date = params[:month] ? Date.strptime(params[:month], "%Y-%m") : Date.today
    @quotes = Quote.applicable.where(removal_at: (@date - 1.month).beginning_of_month..(@date + 1.month).end_of_month).order('removal_at')
  end
  
  def daily
    set_tab :calendar
    @day = params[:day] ? Date.strptime(params[:day], "%Y-%m-%d") : Date.today
    @quotes = Quote.applicable.includes(:from_address => [:address], :to_addresses => [:address]).confirmed.where(removal_at: @day.beginning_of_day..@day.end_of_day).order('removal_at')
  end
  
  def daily_update
    @quote.assign_attributes(params[:quote])

    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: "#{Quote.model_name.human} #{t 'updated'}" }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end
  
  def reject
    @quote.status = "rejected"
    @quote.rejected_by = current_user.id
    @quote.rejected_at = Time.zone.now
    
    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: "#{Quote.model_name.human} #{t 'rejected'}" }
        format.json { head :no_content }
      else
        format.html { redirect_to @quote, alert: "#{t 'failed_to_reject'}" }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def cancel_reject
    @quote.status = "pending"
    @quote.rejected_by = nil
    @quote.rejected_at = nil
    
    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: "#{Quote.model_name.human} #{t 'revert_to_pending'}" }
        format.json { head :no_content }
      else
        format.html { redirect_to @quote, alert: "#{t 'failed_to_cancel_rejection'}" }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def email
    Mailer.quote_email(@quote).deliver
    respond_to do |format|
      format.html { redirect_to @quote, notice: "#{t 'quote_email_notification', default: "Quote was successfully sent to "} #{@quote.client.email}" }
      format.json { render json: @quote }
    end
  end
  
  def print
    to_ids = params[:to] || []
    @to_addresses = @quote.to_addresses.select {|a| to_ids.include?(a.id.to_s) }
    respond_to do |format|
      format.html
      format.pdf do
        pdf = QuotePdf.new(@quote, @to_addresses, false)
        send_data pdf.render, filename: "quote_#{@quote.code}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def fullprint
    to_ids = params[:to] || []
    @to_addresses = @quote.to_addresses.select {|a| to_ids.include?(a.id.to_s) }
    respond_to do |format|
      format.pdf do
        pdf = QuotePdf.new(@quote, @to_addresses, true)
        send_data pdf.render, filename: "quote_#{@quote.code}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def export_payments
    respond_to do |format|
      format.csv { 
        content = Quote.export_payments(current_account, params[:quotes])
        content = Iconv.conv('ISO-8859-1','UTF-8', content)
        send_data content, 
          :filename => "payments.csv", 
          :type => 'text/csv; charset=utf-8; header=present',
          :disposition => "attachment"
      }
    end
  end
  
private

  def load_quote
    @quote = Quote.includes(:from_address, :to_addresses, :quote_forfaits, :quote_supplies, :quote_documents, :quote_trucks, 
                            :quote_confirmation, :furniture, :rooms).find_by_code(params[:id])
  end
  
  def sort_column
    params[:sort].present? ? params[:sort] : "quotes.created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
  def correct_stale_record_version
    @quote.reload
  end

end