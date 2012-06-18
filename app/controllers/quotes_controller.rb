class QuotesController < ApplicationController
  load_and_authorize_resource
  before_filter :load_quote, :only => [:show, :edit, :update, :destroy, :daily_update, :terms, :reject, :sign, :print]
  helper_method :sort_column
  set_tab :quotes
  
  def index
    if params[:search].present?
      @quotes = current_account.quotes.includes(:client, :creator).search_by_keyword(params[:search]).page(params[:page])
    else
      @quotes = current_account.quotes.includes(:client, :creator).order(sort_column + " " + sort_direction).page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quotes }
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
    @client = Client.find(params[:client_id]) if params[:client_id].present?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quote }
    end
  end

  def edit
    puts I18n.locale    
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
  
  def pending
    if params[:day]
      @day = Time.zone.parse(params[:day]).to_date
      puts @day
      @quotes = current_account.quotes.by_day(@day).pending.order('removal_at ASC').order(sort_column + " " + sort_direction).page(params[:page])
    else
      @day = Time.zone.today
      @quotes = current_account.quotes.today.pending.order('removal_at ASC').order(sort_column + " " + sort_direction).page(params[:page])
    end

    respond_to do |format|
      format.html
      format.json { render json: @quotes }
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
      format.html { redirect_to @quote, notice: "#{t 'email_notification', default: "Quote was successfully sent to "} #{@quote.client.email}" }
      format.json { render json: @quote }
    end
  end
  
  def print
    to_ids = params[:to] || []
    @to_addresses = @quote.to_addresses.select {|a| to_ids.include?(a.id.to_s) }
    respond_to do |format|
      format.html
      format.pdf { render :text => PDFKit.new(render_to_string(:formats => [:html], :layout => 'print')).to_pdf }
    end
  end
  
private

  def load_quote
    @quote = Quote.includes(:from_address, :to_addresses, :quote_forfaits, :quote_supplies, :quote_documents, :quote_trucks, 
                            :quote_confirmation, :furniture, :rooms).find(params[:id])
  end
  
  def sort_column
    params[:sort].present? ? params[:sort] : "date"
  end
  
  def correct_stale_record_version
    @quote.reload
  end

end