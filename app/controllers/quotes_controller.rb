class QuotesController < ApplicationController
  load_and_authorize_resource
  before_filter :load_quote, :only => [:show, :edit, :update, :destroy, :daily_update, :terms, :reject, :sign]
  helper_method :sort_column
  set_tab :quotes
  
  # GET /quotes
  # GET /quotes.json
  def index
    @quotes = current_account.quotes.order(sort_column + " " + sort_direction).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quotes }
    end
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quote }
    end
  end

  # GET /quotes/new
  # GET /quotes/new.json
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

  # GET /quotes/1/edit
  def edit
  end

  # POST /quotes
  # POST /quotes.json
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

  # PUT /quotes/1
  # PUT /quotes/1.json
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

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy
    @quote.destroy

    respond_to do |format|
      format.html { redirect_to quotes_url }
      format.json { head :no_content }
    end
  end
  
  def pending
    @quotes = current_account.quotes.pending.order('removal_at ASC').order(sort_column + " " + sort_direction).page(params[:page])

    respond_to do |format|
      format.html { render action: 'index' }
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
  
  # ======================================
  # MOBILE ACTIONS
  # ======================================
  def terms
    session[:current_view] = "terms"
    set_tab :terms

    respond_to do |format|
      format.html { render layout: 'mobile' }
      format.json { render json: @quote }
    end
  end
  
  def sign
    authorize! :sign, @quote
    @quote.assign_attributes(params[:quote])
    @quote.signed_at = Time.now unless @quote.signature.blank?
    if @quote.save
      @quote.create_invoice!(
        payment_method: @quote.quote_confirmation.payment_method
      )
      @quote.create_report!(gas: @quote.gas, start_time: @quote.removal_at)
      redirect_to terms_quote_url(@quote), notice: "#{Quote.model_name.human} #{t 'signed'}"
    else
      redirect_to terms_quote_url(@quote), alert: "Quote cannot be saved, please contact system administrator"
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
