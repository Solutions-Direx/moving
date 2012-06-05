class StoragesController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column
  
  # GET /storages
  # GET /storages.json
  def index
    @storages = current_account.storages.order(sort_column + " " + sort_direction).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @storages }
    end
  end

  # GET /storages/1
  # GET /storages/1.json
  def show
    @storage = Storage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @storage }
    end
  end

  # GET /storages/new
  # GET /storages/new.json
  def new
    @storage = current_account.storages.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @storage }
    end
  end

  # GET /storages/1/edit
  def edit
    @storage = Storage.find(params[:id])
  end

  # POST /storages
  # POST /storages.json
  def create
    @storage = current_account.storages.new(params[:storage])

    respond_to do |format|
      if @storage.save
        format.html { redirect_to storages_url, notice: "#{Storage.model_name.human} #{t 'is_created'}" }
        format.json { render json: @storage, status: :created, location: @storage }
      else
        format.html { render action: "new" }
        format.json { render json: @storage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /storages/1
  # PUT /storages/1.json
  def update
    @storage = Storage.find(params[:id])

    respond_to do |format|
      if @storage.update_attributes(params[:storage])
        format.html { redirect_to storages_url, notice: "#{Storage.model_name.human} #{t 'is_updated'}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @storage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /storages/1
  # DELETE /storages/1.json
  def destroy
    @storage = Storage.find(params[:id])
    @storage.destroy

    respond_to do |format|
      format.html { redirect_to storages_url, notice: "#{Storage.model_name.human} #{t 'is_deleted'}" }
      format.json { head :no_content }
    end
  end
  
private
  
  def sort_column
    Storage.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
end
