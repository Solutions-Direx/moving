class UsersController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column

  def index
    @users = current_account.users.where("id != ?", current_user.id).order(sort_column + " " + sort_direction).page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = current_account.users.new(params[:user])
    generated_password = Devise.friendly_token.first(6)
    @user.password = generated_password
    @user.password_confirmation = generated_password
    
    respond_to do |format|
      if @user.save
        Mailer.user_created_email(@user, generated_password).deliver
        format.html { redirect_to @user, notice: "#{User.model_name.human} #{t 'is_created'}. #{t 'an_email_was_sent_to', default: 'An email was sent to'} #{@user.email}." }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: "#{User.model_name.human} #{t 'is_updated'}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "#{User.model_name.human} #{t 'is_deleted'}" }
      format.json { head :no_content }
    end
  end
  
  def deactivate
    @user = User.find(params[:id])
    @user.active = false

    if @user.save
      redirect_to users_url, notice: "#{@user.full_name} #{t 'is_now_deactivated', default: 'is deactivated'}."
    else
      redirect_to users_url, alert: "Cannot deactivate user #{@user.full_name}. Please contact system administrator."
    end
  end

  def activate
    @user = User.find(params[:id])
    @user.active = true

    if @user.save
      redirect_to users_url, notice: "#{@user.full_name} #{t 'is_now_activated', default: 'is activated'}."
    else
      redirect_to users_url, alert: "Cannot activate user #{@user.full_name}. Please contact system administrator."
    end
  end
  
private
  
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "first_name"
  end
  
end