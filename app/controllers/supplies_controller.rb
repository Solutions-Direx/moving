class SuppliesController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column

  # GET /supplies
  # GET /supplies.json
  def index
    @supplies = current_account.supplies.order(sort_column + " " + sort_direction).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @supplies }
    end
  end

  # GET /supplies/1
  # GET /supplies/1.json
  def show
    @supply = Supply.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @supply }
    end
  end

  # GET /supplies/new
  # GET /supplies/new.json
  def new
    @supply = current_account.supplies.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @supply }
    end
  end

  # GET /supplies/1/edit
  def edit
    @supply = Supply.find(params[:id])
  end

  # POST /supplies
  # POST /supplies.json
  def create
    @supply = current_account.supplies.new(params[:supply])

    respond_to do |format|
      if @supply.save
        format.html { redirect_to supplies_url, notice: "#{Supply.model_name.human} #{t 'is_created'}" }
        format.json { render json: @supply, status: :created, location: @supply }
      else
        format.html { render action: "new" }
        format.json { render json: @supply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /supplies/1
  # PUT /supplies/1.json
  def update
    @supply = Supply.find(params[:id])

    respond_to do |format|
      if @supply.update_attributes(params[:supply])
        format.html { redirect_to supplies_url, notice: "#{Supply.model_name.human} #{t 'is_updated'}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @supply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supplies/1
  # DELETE /supplies/1.json
  def destroy
    @supply = Supply.find(params[:id])
    @supply.destroy

    respond_to do |format|
      format.html { redirect_to supplies_url, notice: "#{Supply.model_name.human} #{t 'is_deleted'}" }
      format.json { head :no_content }
    end
  end

private

  def sort_column
    Supply.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
end
