class DocumentsController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column
  set_tab :documents
  
  def index
    @documents = current_account.documents.order(sort_column + " " + sort_direction).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  def show
    @document = Document.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  def new
    @document = Document.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
    end
  end

  def edit
    @document = Document.find(params[:id])
  end

  def create
    @document = current_account.documents.new(params[:document])

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: "Document #{t 'is_created'}" }
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to @document, notice: "Document #{t 'updated'}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end
  
  def print
    respond_to do |format|
      format.html
      format.pdf { render :text => PDFKit.new(render_to_string(:formats => [:html], :layout => 'print')).to_pdf }
    end
  end
  
private
  
  def sort_column
    Document.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
end