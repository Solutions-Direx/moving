class AccountsController < ApplicationController

  def edit
    @account = current_account
  end

  def update
    @account = current_account

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to current_user_account_url, notice: 'Account was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end
end
