class TrucksController < ApplicationController

  def index
    @trucks = current_account.trucks.sorted

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trucks }
    end
  end

  def show
    @truck = Truck.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @truck }
    end
  end

  def new
    @truck = Truck.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @truck }
    end
  end

  def edit
    @truck = Truck.find(params[:id])
  end

  def create
    @truck = current_account.trucks.build(params[:truck])

    respond_to do |format|
      if @truck.save
        format.html { redirect_to trucks_url, notice: "#{Truck.model_name.human} #{t 'is_created'}" }
        format.json { render json: @truck, status: :created, location: @truck }
      else
        format.html { render action: "new" }
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @truck = Truck.find(params[:id])

    respond_to do |format|
      if @truck.update_attributes(params[:truck])
        format.html { redirect_to trucks_url, notice: "#{Truck.model_name.human} #{t 'is_updated'}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @truck = Truck.find(params[:id])
    @truck.destroy

    respond_to do |format|
      format.html { redirect_to trucks_url, notice: "#{Truck.model_name.human} #{t 'is_deleted'}" }
      format.json { head :no_content }
    end
  end
end
