class AnnexesController < ApplicationController
  # GET /annexes
  # GET /annexes.json
  def index
    @annexes = Annex.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @annexes }
    end
  end

  # GET /annexes/1
  # GET /annexes/1.json
  def show
    @annex = Annex.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @annex }
    end
  end

  # GET /annexes/new
  # GET /annexes/new.json
  def new
    @storage = Storage.find(params[:storage_id])
    @annex = @storage.annexes.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @annex }
    end
  end

  # GET /annexes/1/edit
  def edit
    @storage = Storage.find(params[:storage_id])
    @annex = @storage.annexes.find(params[:id])
  end

  # POST /annexes
  # POST /annexes.json
  def create
    @storage = Storage.find(params[:storage_id])
    @annex = @storage.annexes.new(params[:annex])

    respond_to do |format|
      if @annex.save
        format.html { redirect_to @storage, notice: 'Annex was successfully created.' }
        format.json { render json: @annex, status: :created, location: @annex }
      else
        format.html { render action: "new" }
        format.json { render json: @annex.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /annexes/1
  # PUT /annexes/1.json
  def update
    @storage = Storage.find(params[:storage_id])
    @annex = @storage.annexes.find(params[:id])

    respond_to do |format|
      if @annex.update_attributes(params[:annex])
        format.html { redirect_to storage_annex_path(@storage, @annex), notice: 'Annex was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @annex.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /annexes/1
  # DELETE /annexes/1.json
  def destroy
    @storage = Storage.find(params[:storage_id])
    @annex = @storage.annexes.find(params[:id])
    @annex.destroy

    respond_to do |format|
      format.html { redirect_to @storage, notice: 'Annex was successfully deleted' }
      format.json { head :no_content }
    end
  end
end
