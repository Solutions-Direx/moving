class ProfilesController < ApplicationController
  
  def show
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_with_password(params[:user])
      sign_in @user, :bypass => true
      redirect_to profile_url, notice: "#{t 'profile', default: 'Profile'} #{t 'is_updated'}"
    else
      @user.password = ""
      @user.password_confirmation = ""
      render :show
    end
  end
end