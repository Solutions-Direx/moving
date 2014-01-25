class ClientsController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column
  set_tab :clients
  
  def index
    if params[:search].present?
      query = params[:search].gsub(".", " ")
      @clients = current_account.clients.includes(:address).search_by_keyword(query).page(params[:page])
    else
      @clients = current_account.clients.includes(:address).order(sort_column + " " + sort_direction).page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clients }
    end
  end

  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client.to_json(:include => :address) }
      format.js
    end
  end

  def new
    @client = current_account.clients.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client }
      format.js
    end
  end

  def edit
    @client = Client.find(params[:id])
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client }
      format.js
    end
  end

  def create
    @client = current_account.clients.new(params[:client])

    respond_to do |format|
      if @client.save
        format.html {
          if request.xhr?
            render partial: "flash_modal_msg", locals: { message: "Client #{t 'is_created'}", close_dialog_id: "new-client", client: @client }
          else
            redirect_to @client, notice: "Client #{t 'is_created'}"
          end
        }
        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { render action: "new", layout: !request.xhr? }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { 
          if request.xhr?
            render partial: "flash_modal_msg", locals: { message: "Client was successfully updated.", close_dialog_id: "edit-client", client: @client }
          else
            redirect_to @client, notice: "Client #{t 'is_updated'}"
          end
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit", layout: !request.xhr? }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.can_be_deleted?
        @client.destroy
        format.html { redirect_to clients_url, notice: "Client #{@client.name} was successfully deleted." }
        format.json { head :no_content }
      else
        format.html { redirect_to client_url(@client), alert: "Client cannot be deleted because of associated quotes/invoices." }
      end
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