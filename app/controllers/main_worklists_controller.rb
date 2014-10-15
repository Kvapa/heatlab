class MainWorklistsController < ApplicationController
  before_filter :authorize
  before_filter :authorize_admin
  # GET /main_worklists
  # GET /main_worklists.json
  def index
    @main_worklists = MainWorklist.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @main_worklists }
    end
  end

  # GET /main_worklists/1
  # GET /main_worklists/1.json
  def show
    @main_worklist = MainWorklist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @main_worklist }
    end
  end

  # GET /main_worklists/new
  # GET /main_worklists/new.json
  def new
    @main_worklist = MainWorklist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @main_worklist }
    end
  end

  # GET /main_worklists/1/edit
  def edit
    @main_worklist = MainWorklist.find(params[:id])
  end

  # POST /main_worklists
  # POST /main_worklists.json
  def create
    @main_worklist = MainWorklist.new(params[:main_worklist])

    respond_to do |format|
      if @main_worklist.save
        format.html { redirect_to main_worklists_path, notice: 'Main worklist was successfully created.' }
        format.json { render json: @main_worklist, status: :created, location: @main_worklist }
      else
        format.html { render action: "new" }
        format.json { render json: @main_worklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /main_worklists/1
  # PUT /main_worklists/1.json
  def update
    @main_worklist = MainWorklist.find(params[:id])

    respond_to do |format|
      if @main_worklist.update_attributes(params[:main_worklist])
        format.html { redirect_to main_worklists_path, notice: 'Main worklist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @main_worklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /main_worklists/1
  # DELETE /main_worklists/1.json
  def destroy
    @main_worklist = MainWorklist.find(params[:id])
    @main_worklist.destroy

    respond_to do |format|
      format.html { redirect_to main_worklists_url }
      format.json { head :no_content }
    end
  end

end
