class ProjectActivitiesController < ApplicationController
   before_filter :authorize
   before_filter :authorize_admin
  # GET /project_activities
  # GET /project_activities.json
  def index
    @project = Project.find(params[:project_id])
    @project_position = ProjectPosition.find(params[:project_position_id])
    @project_activities = @project_position.project_activities.order("position")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_activities }
    end
  end

  # GET /project_activities/1
  # GET /project_activities/1.json
  def show
    @project_activity = ProjectActivity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project_activity }
    end
  end

  # GET /project_activities/new
  # GET /project_activities/new.json
  def new
    @project = Project.find(params[:project_id])
    @project_position = ProjectPosition.find(params[:project_position_id])
    @project_activity = ProjectActivity.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project_activity }
    end
  end

  # GET /project_activities/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @project_position = ProjectPosition.find(params[:project_position_id])
    @project_activity = ProjectActivity.find(params[:id])
  end

  # POST /project_activities
  # POST /project_activities.json
  def create
    @project_activity = ProjectActivity.new(params[:project_activity])

    respond_to do |format|
      if @project_activity.save
        format.html { redirect_to project_project_position_project_activities_path, notice: 'Project activity was successfully created.' }
        format.json { render json: @project_activity, status: :created, location: @project_activity }
      else
        format.html { render action: "new" }
        format.json { render json: @project_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /project_activities/1
  # PUT /project_activities/1.json
  def update
    @project_activity = ProjectActivity.find(params[:id])

    respond_to do |format|
      if @project_activity.update_attributes(params[:project_activity])
        format.html { redirect_to project_project_position_project_activities_path, notice: 'Project activity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_activities/1
  # DELETE /project_activities/1.json
  def destroy
    @project_activity = ProjectActivity.find(params[:id])
    @project_activity.destroy

    respond_to do |format|
      format.html { redirect_to project_activities_url }
      format.json { head :no_content }
    end
  end
  def sort
    params[:project_activity].each_with_index do |id, index|
      ProjectActivity.update_all({position: index+1}, {id: id}) 
    end
    render nothing: true
  end
end
