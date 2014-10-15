#encoding: utf-8
class EventsController < ApplicationController
  before_filter :authorize
  before_filter :authorize_admin
  # GET /events
  # GET /events.json
  def index
    @project = Project.find(params[:project_id])
    @events = @project.events.order("day DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @project = Project.find(params[:project_id])
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to project_events_path, notice: 'Akce byla úspěšně vytvořena.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @project = Project.find(params[:project_id])
    @event = Event.find(params[:id])
    if !params[:event][:eventgroup].blank?
     params[:event][:user_ids] = Eventgroup.find(params[:event][:eventgroup]).user_ids
    end
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to project_events_path, notice: 'Akce byla úspěšně změněna.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to project_events_path }
      format.json { head :no_content }
    end
  end
end
