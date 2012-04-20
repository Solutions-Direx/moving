class QuotesController < ApplicationController
  load_and_authorize_resource
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
    @quote = Quote.find(params[:id])

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
    @quote = Quote.find(params[:id])
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
    @quote = Quote.find(params[:id])
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
    @quote = Quote.find(params[:id])
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
    @quotes = Quote.where(removal_at: (@date - 1.month).beginning_of_month..(@date + 1.month).end_of_month)
  end
  
  def daily
    set_tab :calendar
    @day = params[:day] ? Date.strptime(params[:day], "%Y-%m-%d") : Date.today
    @quotes = Quote.where(removal_at: @day.beginning_of_day..@day.end_of_day)
  end
  
private
  
  def sort_column
    Quote.column_names.include?(params[:sort]) ? params[:sort] : "date"
  end
end
