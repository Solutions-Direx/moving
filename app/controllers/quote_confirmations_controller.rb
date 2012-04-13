class QuoteConfirmationsController < ApplicationController

  def new
    @quote = Quote.find(params[:id])
    @quote_confirmation = @quote.build_quote_confirmation(:user_id => current_user.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quote_confirmation }
      format.js
    end
  end

  def edit
    @quote_confirmation = QuoteConfirmation.find(params[:id])
  end

  def create
    @quote = Quote.find(params[:quote_id])
    @quote_confirmation = @quote.create_quote_confirmation(params[:quote_confirmation])
    @quote_confirmation.approved_at = Time.zone.now
    @quote_confirmation.user_id = current_user

    respond_to do |format|
      if @quote_confirmation.save
        format.html { redirect_to @quote, notice: 'Quote was successfully confirmed.' }
        format.json { render json: @quote_confirmation, status: :created, location: @quote_confirmation }
      else
        format.html { render action: "new" }
        format.json { render json: @quote_confirmation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @quote_confirmation = QuoteConfirmation.find(params[:id])

    respond_to do |format|
      if @quote_confirmation.update_attributes(params[:quote_confirmation])
        format.html { redirect_to @quote_confirmation, notice: 'Quote confirmation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quote_confirmation.errors, status: :unprocessable_entity }
      end
    end
  end

end