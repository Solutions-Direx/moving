class QuoteConfirmationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_quote
  
  def show
    @quote_confirmation = @quote.quote_confirmation
    render :layout => false
  end

  def new
    @quote_confirmation = @quote.build_quote_confirmation(:user_id => current_user.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quote_confirmation }
      format.js
    end
  end

  def edit
    @quote_confirmation = @quote.quote_confirmation
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quote_confirmation }
      format.js
    end
  end

  def create
    @quote_confirmation = @quote.create_quote_confirmation(params[:quote_confirmation])
    @quote_confirmation.approved_at = Time.zone.now
    @quote_confirmation.user_id = current_user.id

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
    @quote_confirmation = @quote.quote_confirmation

    respond_to do |format|
      if @quote_confirmation.update_attributes(params[:quote_confirmation])
        format.html { 
          if request.xhr?
            render :partial => "flash_modal_msg", :locals => { :notice => "Confirmation #{t 'updated'}", :close_dialog_id => "new-quote-confirmation" }
          else
            redirect_to @quote, notice: "Confirmation #{t 'updated'}" 
          end
        }
        format.json { render json: @quote_confirmation, status: :created, location: @quote_confirmation }
      else
        format.html { render action: "edit", layout: !request.xhr? }
        format.json { render json: @quote_confirmation.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @quote_confirmation = @quote.quote_confirmation
    respond_to do |format|
      if @quote_confirmation.destroy
        @quote.status = "pending"
        @quote.save
        format.html { redirect_to quote_path(@quote), notice: "#{Quote.model_name.human} #{t 'revert_to_pending'}" }
      else
        format.html { redirect_to quote_path(@quote), alert: "#{t 'failed_to_deleted_confirmation'}" }
      end
    end
  end
  
private
  
  def load_quote
    @quote = Quote.find(params[:quote_id])
  end

end