require 'teamlab'

class ListDocumentsController < ApplicationController
  include ListDocumentsHelper
  before_action :set_list_document, only: [:show, :edit, :update, :destroy, :download, :upload_to_teamlab]
  before_action :authenticate_to_teamlab, only: [:upload_to_teamlab]

  # GET /list_documents
  # GET /list_documents.json
  def index
    @list_documents ||= ListDocument.all.to_a
  end

  # GET /list_documents/1
  # GET /list_documents/1.json
  def show
    @document = ListDocument.find(params[:id]).document
  end

  # GET /list_documents/new
  def new
    @list_document = ListDocument.new
  end

  # GET /list_documents/1/edit
  def edit
  end

  # POST /list_documents
  # POST /list_documents.json
  def create
    @list_document = ListDocument.new(list_document_params)

    respond_to do |format|
      if @list_document.save
        format.html { redirect_to @list_document, notice: 'List document was successfully created.' }
        format.json { render :show, status: :created, location: @list_document }
      else
        format.html { render :new }
        format.json { render json: @list_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /list_documents/1
  # PATCH/PUT /list_documents/1.json
  def update
    respond_to do |format|
      if @list_document.update(list_document_params)
        format.html { redirect_to @list_document, notice: 'List document was successfully updated.' }
        format.json { render :show, status: :ok, location: @list_document }
      else
        format.html { render :edit }
        format.json { render json: @list_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /list_documents/1
  # DELETE /list_documents/1.json
  def destroy
    @list_document.destroy
    respond_to do |format|
      format.html { redirect_to list_documents_url, notice: 'List document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download
    send_file @list_document.attributes['path'], :type=>"application/xml", :x_sendfile=>true
  end

  def upload_to_teamlab
    file_id = Teamlab.files.upload_to_my_docs(@list_document.attributes['path']).body['response']['id']
    respond_to do |format|
      format.html { redirect_to Teamlab.files.generate_shared_link(file_id, 'ReadWrite').body['response']}
    end
  end

  def filter
    @list_documents ||= filter_documents(params)
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list_document
      @list_document = ListDocument.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_document_params
      params[:list_document]
    end

    def authenticate_to_teamlab
      Teamlab.configure do |config|
        config.server = TM_PORTAL
        config.username = USERNAME
        config.password = PASSWORD
      end
    end
end
