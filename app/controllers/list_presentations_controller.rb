class ListPresentationsController < ApplicationController
  include ListPresentationsHelper

  before_action :set_list_presentation, only: [:show, :edit, :update, :destroy, :download, :upload_to_teamlab, :open_on_testrail]
  before_action :authenticate_to_teamlab, only: [:upload_to_teamlab]

  # GET /list_presentations
  # GET /list_presentations.json
  def index
    @list_presentations = ListPresentation.all
  end

  # GET /list_presentations/1
  # GET /list_presentations/1.json
  def show
    @presentation = ListPresentation.find(params[:id]).presentation['structure']
    respond_to do |format|
      format.html
      format.xml { render xml: @presentation }
    end
  end

  # GET /list_presentations/new
  def new
    @list_presentation = ListPresentation.new
  end

  # GET /list_presentations/1/edit
  def edit
  end

  # POST /list_presentations
  # POST /list_presentations.json
  def create
    @list_presentation = ListPresentation.new(list_presentation_params)

    respond_to do |format|
      if @list_presentation.save
        format.html { redirect_to @list_presentation, notice: 'List presentation was successfully created.' }
        format.json { render :show, status: :created, location: @list_presentation }
      else
        format.html { render :new }
        format.json { render json: @list_presentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /list_presentations/1
  # PATCH/PUT /list_presentations/1.json
  def update
    respond_to do |format|
      if @list_presentation.update(list_presentation_params)
        format.html { redirect_to @list_presentation, notice: 'List presentation was successfully updated.' }
        format.json { render :show, status: :ok, location: @list_presentation }
      else
        format.html { render :edit }
        format.json { render json: @list_presentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /list_presentations/1
  # DELETE /list_presentations/1.json
  def destroy
    @list_presentation.destroy
    respond_to do |format|
      format.html { redirect_to list_presentations_url, notice: 'List presentation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download
    send_file @list_presentation.attributes['path'], :type=>"application/xml", :x_sendfile=>true
  end

  def upload_to_teamlab
    file_id = Teamlab.files.upload_to_my_docs(@list_presentation.attributes['path']).body['response']['id']
    respond_to do |format|
      format.html { redirect_to Teamlab.files.generate_shared_link(file_id, 'ReadWrite').body['response']}
    end
  end

  def filter
    @list_presentations ||= filter_presentations(params)
    respond_to do |format|
      format.js
    end
  end

  def open_on_testrail
    case_id = Testrail2.new.project(68).suite(16981).section(35127).case(@list_presentation.attributes['path']).id
    respond_to do |format|
      format.html { redirect_to "http://tm-testrail.no-ip.org/testrail/index.php?/cases/results/#{case_id}"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list_presentation
      @list_presentation = ListPresentation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_presentation_params
      params[:list_presentation]
    end

  def authenticate_to_teamlab
    Teamlab.configure do |config|
      config.server = TEAMLAB[:server]
      config.username = TEAMLAB[:username]
      config.password = TEAMLAB[:password]
    end
  end
end
