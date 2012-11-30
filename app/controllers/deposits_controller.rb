class DepositsController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @quote = Quote.find_by_code(params[:quote_id])
    @deposit = @quote.build_deposit
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @deposit }
      format.js
    end
  end

  def edit
    @quote = Quote.find_by_code(params[:quote_id])
    @deposit = @quote.deposit

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  def update
    @quote = Quote.find_by_code(params[:quote_id])
    @deposit = @quote.deposit
    
    respond_to do |format|
      if @deposit.update_attributes(params[:deposit])
        format.html { redirect_to quote_url(@quote), notice: "#{QuoteDeposit.model_name.human} #{t 'is_updated'}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def create
    @quote = Quote.find_by_code(params[:quote_id])
    @deposit = @quote.create_deposit(params[:payment])
    @deposit.creator_id = current_user.id

    respond_to do |format|
      if @deposit.save
        format.html { 
          if request.xhr?
            render partial: "flash_modal_msg", :locals => { notice: "#{t 'deposit_is_confirmed', :default => 'Deposit confirmed'}", :close_dialog_id => "new-quote-deposit" }
          else
            redirect_to @quote, notice: "#{t 'deposit_is_confirmed', :default => 'Deposit confirmed'}" 
          end
        }
        format.json { render json: @deposit, status: :created, location: @deposit }
      else
        format.html { render action: "new", layout: !request.xhr? }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @quote = Quote.find_by_code(params[:quote_id])
    @deposit = @quote.create_deposit(params[:payment])
    @deposit.destroy

    respond_to do |format|
      format.html { redirect_to quote_url(@quote), notice: "#{QuoteDeposit.model_name.human} #{t 'is_deleted'}" }
      format.json { head :no_content }
    end
  end
end