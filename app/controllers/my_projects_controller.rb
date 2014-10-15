class MyProjectsController < ApplicationController
  before_filter :authorize

  def index
  	@user = User.find(current_user)
  	@projects = @user.projects.where("project_id != 5").uniq
  end

  def show
    @user = User.find(current_user)
  	@project = Project.find(params[:id])
    @job = @project.jobs.where("user_id=?",@user.id)[0]
  end

  def showjob
    @user = User.find(current_user)
    @project = Project.find(params[:id])
    @job = Job.find(params[:job_id])
  end

  def worklist
  	@user = User.find(current_user)
  	@project = Project.find(params[:my_project_id])
  	@job = Job.find(params[:job_id])

    if @job.usertype == 0 && @job.joined
    	@main_worklist=MainWorklist.where("year=?",Date.new(params[:year].to_i,1,1))
      @main_job=MainJob.where("main_worklist_id=? AND user_id=?", @main_worklist[0].id, @job.user_id.to_s)
     
      @main_jobmonth=MainJobmonth.where("main_job_id = ? AND month=?", @main_job[0].id, Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month)
      @main_jobdays=MainJobday.all(
        :conditions => {
        :main_job_id => @main_job[0].id, 
        :day => Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month..Date.new(params[:year].to_i,params[:month].to_i).end_of_month
        })
    end
     @month=Jobmonth.all(
      :conditions => {
      :job_id =>@job.id, 
      :month => Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month
    })
    @jobdays=Jobday.all(
      :conditions => {
      :job_id =>@job.id, 
      :day => Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month..Date.new(params[:year].to_i,params[:month].to_i).end_of_month
    },:order => 'day ASC')

    @sum_hours = 0
    @jobdays.each do |day|
      if !day.hours.blank?
        @sum_hours += day.hours
      end  
    end

    @events = Event.where("(day BETWEEN ? AND ?) OR (date_until BETWEEN ? AND ?) ", Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month, Date.new(params[:year].to_i,params[:month].to_i).end_of_month,Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month, Date.new(params[:year].to_i,params[:month].to_i).end_of_month)
  end

  def worklist_update
    @project = Project.find(params[:my_project_id])

    Jobday.update(params[:jobdays].keys, params[:jobdays].values)

    @jobmonth = Jobmonth.find(params[:jobmonth][:id])
    @jobmonth.update_attribute(:filled,params[:jobmonth][:filled])

    redirect_to "/my_projects/" + params[:my_project_id] + "/" + params[:job_id]+ "/worklist/"+params[:year]+"/"+params[:month]
  end
end
