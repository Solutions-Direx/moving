class ClientsController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column
  set_tab :clients
  
  # GET /clients
  # GET /clients.json
  def index
    if params[:search].present?
      @clients = current_account.clients.includes(:address).search_by_keyword(params[:search]).page(params[:page])
    else
      @clients = current_account.clients.includes(:address).order(sort_column + " " + sort_direction).page(params[:page])
    end

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
      format.json { render json: @client.to_json(:include => :address) }
      format.js
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
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client }
      format.js
    end
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = current_account.clients.new(params[:client])

    respond_to do |format|
      if @client.save
        format.html {
          if request.xhr?
            render :partial => "flash_modal_msg", :locals => { :message => "Client was successfully created.", :close_dialog_id => "new-client", :client => @client }
          else
            redirect_to @client, notice: 'Client was successfully created.'
          end
        }
        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { render action: "new", layout: !request.xhr? }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { 
          if request.xhr?
            render :partial => "flash_modal_msg", :locals => { :message => "Client was successfully updated.", :close_dialog_id => "edit-client", :client => @client }
          else
            redirect_to @client, notice: 'Client was successfully updated.'
          end
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit", layout: !request.xhr? }
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
      format.html { redirect_to clients_url, :notice => "Client #{@client.name} was successfully destroy." }
      format.json { head :no_content }
    end
  end
  
  def cities
    @addresses = Address.order("city").where(addressable_type: "Client").where("lower(city) like ?", "%#{params[:term].downcase}%")
    respond_to do |format|
      format.json { render json: @addresses.map{|a| {label: a.city, value: a.city}}}
    end
  end

private

  def sort_column
    Client.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

end