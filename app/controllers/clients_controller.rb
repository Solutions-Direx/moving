class ClientsController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column
  
  # GET /clients
  # GET /clients.json
  def index
    @clients = current_account.clients.order(sort_column + " " + sort_direction).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clients }
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.json
  def new
    @client = current_account.clients.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client }
      format.js
    end
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = current_account.clients.new(params[:client])

    respond_to do |format|
      if @client.save
        flash[:notice] = "Client was successfully created."
        format.html { redirect_to @client }
        format.json { render json: @client, status: :created, location: @client }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { redirect_to @client, notice: 'Client was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
  end

private

  def sort_column
    Client.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

end
