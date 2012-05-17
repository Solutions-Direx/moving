class QuoteConfirmationsController < ApplicationController
  
  def show
    @quote_confirmation = QuoteConfirmation.find(params[:id])
    render :layout => false
  end

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
    @quote = Quote.find(params[:quote_id])
    @quote_confirmation = QuoteConfirmation.find(params[:id])
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quote_confirmation }
      format.js
    end
  end

  def create
    @quote = Quote.find(params[:quote_id])
    @quote_confirmation = @quote.create_quote_confirmation(params[:quote_confirmation])
    @quote_confirmation.approved_at = Time.zone.now
    @quote_confirmation.user_id = current_user

    respond_to do |format|
      if @quote_confirmation.save
        format.html { 
          if request.xhr?
            render partial: "flash_modal_msg", :locals => { notice: "#{t 'quote_is_confirmed'}", :close_dialog_id => "new-quote-confirmation" }
          else
            redirect_to @quote, notice: "#{t 'quote_is_confirmed'}" 
          end
        }
        format.json { render json: @quote_confirmation, status: :created, location: @quote_confirmation }
      else
        format.html { render action: "new", layout: !request.xhr? }
        format.json { render json: @quote_confirmation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @quote_confirmation = QuoteConfirmation.find(params[:id])

    respond_to do |format|
      if @quote_confirmation.update_attributes(params[:quote_confirmation])
        format.html { 
          if request.xhr?
            render :partial => "flash_modal_msg", :locals => { :message => "Confirmation was successfully updated.", :close_dialog_id => "new-quote-confirmation" }
          else
            redirect_to @quote, notice: 'Confirmation was successfully updated.' 
          end
        }
        format.json { render json: @quote_confirmation, status: :created, location: @quote_confirmation }
      else
        format.html { render action: "edit", layout: !request.xhr? }
        format.json { render json: @quote_confirmation.errors, status: :unprocessable_entity }
      end
    end
  end

end
