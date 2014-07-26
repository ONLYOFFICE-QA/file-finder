require_relative '../../../SharedFunctional/TestrailAPI/API2.0/Testrail'
require 'teamlab'

class ListSpreadsheetsController < ApplicationController
  include ListSpreadsheetsHelper
  before_action :set_list_spreadsheet, only: [:show, :edit, :update, :destroy, :download, :upload_to_teamlab, :open_on_testrail]
  before_action :authenticate_to_teamlab, only: [:upload_to_teamlab]

  # GET /list_spreadsheets
  # GET /list_spreadsheets.json
  def index
    @list_spreadsheets = ListSpreadsheet.all.to_a
  end

  # GET /list_spreadsheets/1
  # GET /list_spreadsheets/1.json
  def show
    @spreadsheet = ListSpreadsheet.find(params[:id]).spreadsheet['structure']
    respond_to do |format|
      format.html
      format.xml { render xml: @spreadsheet }
    end
  end

  # GET /list_spreadsheets/new
  def new
    @list_spreadsheet = ListSpreadsheet.new
  end

  # GET /list_spreadsheets/1/edit
  def edit
  end

  # POST /list_spreadsheets
  # POST /list_spreadsheets.json
  def create
    @list_spreadsheet = ListSpreadsheet.new(list_spreadsheet_params)

    respond_to do |format|
      if @list_spreadsheet.save
        format.html { redirect_to @list_spreadsheet, notice: 'List spreadsheet was successfully created.' }
        format.json { render :show, status: :created, location: @list_spreadsheet }
      else
        format.html { render :new }
        format.json { render json: @list_spreadsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /list_spreadsheets/1
  # PATCH/PUT /list_spreadsheets/1.json
  def update
    respond_to do |format|
      if @list_spreadsheet.update(list_spreadsheet_params)
        format.html { redirect_to @list_spreadsheet, notice: 'List spreadsheet was successfully updated.' }
        format.json { render :show, status: :ok, location: @list_spreadsheet }
      else
        format.html { render :edit }
        format.json { render json: @list_spreadsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /list_spreadsheets/1
  # DELETE /list_spreadsheets/1.json
  def destroy
    @list_spreadsheet.destroy
    respond_to do |format|
      format.html { redirect_to list_spreadsheets_url, notice: 'List spreadsheet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download
    send_file @list_spreadsheet.attributes['path'], :type=>"application/xml", :x_sendfile=>true
  end

  def upload_to_teamlab
    file_id = Teamlab.files.upload_to_my_docs(@list_spreadsheet.attributes['path']).body['response']['id']
    respond_to do |format|
      format.html { redirect_to Teamlab.files.generate_shared_link(file_id, 'ReadWrite').body['response']}
    end
  end

  def filter
    @list_spreadsheets ||= filter_spreadsheets(params)
    respond_to do |format|
      format.js
    end
  end

  def open_on_testrail
    case_id = Testrail2.new.project(68).suite(39834).section(58251).case(@list_spreadsheet.attributes['path']).id
    respond_to do |format|
      format.html { redirect_to "http://tm-testrail.no-ip.org/testrail/index.php?/cases/results/#{case_id}"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list_spreadsheet
      @list_spreadsheet = ListSpreadsheet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_spreadsheet_params
      params[:list_spreadsheet]
    end

    def authenticate_to_teamlab
      Teamlab.configure do |config|
        config.server = TEAMLAB[:server]
        config.username = TEAMLAB[:username]
        config.password = TEAMLAB[:password]
      end
    end
end
