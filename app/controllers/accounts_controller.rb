class AccountsController < ApplicationController
  load_and_authorize_resource
  
  def show
    @account = current_account
  end

  def update
    @account = current_account

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to account_url, notice: "#{t 'settings'} #{t 'is_updated'}" }
      else
        format.html { render action: "show" }
      end
    end
  end
end
