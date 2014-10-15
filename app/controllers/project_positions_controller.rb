class ProjectPositionsController < ApplicationController
   before_filter :authorize
   before_filter :authorize_admin
  # GET /project_positions
  # GET /project_positions.json

  def index
    @project = Project.find(params[:project_id])
    @project_positions = @project.project_positions.order("position")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_positions }
    end
  end

  # GET /project_positions/1
  # GET /project_positions/1.json
  def show
    @project_position = ProjectPosition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project_position }
    end
  end

  # GET /project_positions/new
  # GET /project_positions/new.json
  def new
    @project = Project.find(params[:project_id])
    @project_position = ProjectPosition.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project_position }
    end
  end

  # GET /project_positions/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @project_position = ProjectPosition.find(params[:id])
  end

  # POST /project_positions
  # POST /project_positions.json
  def create
    @project_position = ProjectPosition.new(params[:project_position])

    respond_to do |format|
      if @project_position.save
        format.html { redirect_to project_project_positions_path, notice: 'Project position was successfully created.' }
        format.json { render json: @project_position, status: :created, location: @project_position }
      else
        format.html { render action: "new" }
        format.json { render json: @project_position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /project_positions/1
  # PUT /project_positions/1.json
  def update
    @project_position = ProjectPosition.find(params[:id])

    respond_to do |format|
      if @project_position.update_attributes(params[:project_position])
        format.html { redirect_to project_project_positions_path, notice: 'Project position was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_positions/1
  # DELETE /project_positions/1.json
  def destroy
    @project_position = ProjectPosition.find(params[:id])
    @project_position.destroy

    respond_to do |format|
      format.html { redirect_to project_project_positions_url }
      format.json { head :no_content }
    end
  end

  def sort
    params[:project_position].each_with_index do |id, index|
      ProjectPosition.update_all({position: index+1}, {id: id}) 
    end
    render nothing: true
  end
end
