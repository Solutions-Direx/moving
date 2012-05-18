class QuotesController < ApplicationController
  load_and_authorize_resource
  before_filter :load_quote, :only => [:show, :edit, :update, :destroy, :daily_update, :terms, :reject, :sign]
  helper_method :sort_column
  set_tab :quotes
  
  def index
    @quotes = current_account.quotes.order(sort_column + " " + sort_direction).page(params[:page])

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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quote }
    end
  end

  def edit
    if @quote.invoice.present? && @quote.invoice.signed?
      
      respond_to do |format|
        format.html { redirect_to @quote, alert: "Quote can no longer be edited once invoice has been signed by client." }
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
        format.html { redirect_to @quote, notice: 'Quote was successfully created.' }
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
        format.html { redirect_to @quote, notice: 'Quote was successfully updated.' }
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
        format.html { redirect_to @quote, notice: 'Quote was successfully updated.' }
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
    @quote.status = "Rejected"
    
    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: 'Quote was successfully rejected.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @quote, alert: 'Failed to reject quote. Please contact system administrator.' }
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
  
private

  def load_quote
    @quote = Quote.find(params[:id])
  end
  
  def sort_column
    Quote.column_names.include?(params[:sort]) ? params[:sort] : "date"
  end
  
  def correct_stale_record_version
    @quote.reload
  end
end
