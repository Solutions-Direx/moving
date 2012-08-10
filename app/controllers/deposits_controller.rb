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
  
  def create
    @quote = Quote.find_by_code(params[:quote_id])
    @deposit = @quote.create_deposit(params[:quote_deposit])

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
end