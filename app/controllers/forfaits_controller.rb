class ForfaitsController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column
  
  # GET /forfaits
  # GET /forfaits.json
  def index
    @forfaits = current_account.forfaits.order(sort_column + " " + sort_direction).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @forfaits }
    end
  end

  # GET /forfaits/1
  # GET /forfaits/1.json
  def show
    @forfait = Forfait.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @forfait }
    end
  end

  # GET /forfaits/new
  # GET /forfaits/new.json
  def new
    @forfait = current_account.forfaits.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @forfait }
    end
  end

  # GET /forfaits/1/edit
  def edit
    @forfait = Forfait.find(params[:id])
  end

  # POST /forfaits
  # POST /forfaits.json
  def create
    @forfait = current_account.forfaits.new(params[:forfait])

    respond_to do |format|
      if @forfait.save
        format.html { redirect_to forfaits_url, notice: 'Forfait was successfully created.' }
        format.json { render json: @forfait, status: :created, location: @forfait }
      else
        format.html { render action: "new" }
        format.json { render json: @forfait.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /forfaits/1
  # PUT /forfaits/1.json
  def update
    @forfait = Forfait.find(params[:id])

    respond_to do |format|
      if @forfait.update_attributes(params[:forfait])
        format.html { redirect_to forfaits_url, notice: 'Forfait was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @forfait.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forfaits/1
  # DELETE /forfaits/1.json
  def destroy
    @forfait = Forfait.find(params[:id])
    @forfait.destroy

    respond_to do |format|
      format.html { redirect_to forfaits_url, notice: 'Forfait was successfully deleted.' }
      format.json { head :no_content }
    end
  end

private

  def sort_column
    Forfait.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
end