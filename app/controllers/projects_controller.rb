class ProjectsController < ApplicationController
  before_filter :authorize
  before_filter :authorize_admin
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.find(:all,:order => "start_date ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to projects_path, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  def jobcheck
    @project = Project.find(params[:project_id])
  end

  def jobcheck_year
    @project = Project.find(params[:project_id])
    @jobs = @project.jobs.find(:all, :joins => :user,:conditions => ["usertype=?",0], :order=> "users.surname")
    @jobsDPP = @project.jobs.find(:all, :joins => :user,:conditions => ["usertype=?",1], :order=> "users.surname")
  end

  def jobcheck_update
    @project = Project.find(params[:project_id])
    @jobs = @project.jobs.find(:all, :joins => :user,:conditions => ["usertype=?",0], :order=> "users.surname") 
    @jobsDPP = @project.jobs.find(:all, :joins => :user,:conditions => ["usertype=?",1], :order=> "users.surname")

    @jobs.each do |job|
      if numeric?(params[job.id.to_s]["hours"])
        params[job.id.to_s].each_with_index do |a,i| 
          if i<params[job.id.to_s].size-1 
            if a[1] == "1"
              jobmonth=Jobmonth.where("job_id=? and month=?",job.id, Date.new(params[:year].to_i,a[0].to_i).beginning_of_month) 
              jobmonth[0].update_attribute(:workload,params[job.id.to_s][:hours].to_f)
            end
          end
        end
      end
    end

    @jobsDPP.each do |job|
      if numeric?(params[job.id.to_s]["hours"])
        params[job.id.to_s].each_with_index do |a,i| 
          if i<params[job.id.to_s].size-1 
            if a[1] == "1"
              jobmonth=Jobmonth.where("job_id=? and month=?",job.id, Date.new(params[:year].to_i,a[0].to_i).beginning_of_month) 
              jobmonth[0].update_attribute(:workload,params[job.id.to_s][:hours].to_f)
            end
          end
        end
      end
    end

    redirect_to  project_jobcheck_path(@project) + "/" +params[:year]
  end
  def numeric?(object)
    true if Float(object) rescue false
  end

  def export_xls
    @project = Project.find(params[:project_id])
    @jobs = @project.jobs.find(:all, :joins => :user,:conditions => ["usertype=?",0], :order=> "users.surname")
    @jobsDPP = @project.jobs.find(:all, :joins => :user,:conditions => ["usertype=?",1], :order=> "users.surname")

    require 'spreadsheet'
    Spreadsheet.client_encoding = 'UTF-8'    
    book = Spreadsheet.open 'public/project-jobs.xls'
    
    sheet = book.worksheet 0

    sheet[0, 1]=@project.workname
    sheet[1, 1]=params[:year]

    @jobs.each_with_index do |job,i|
      user = User.find(job.user_id) 
      sheet[i+5, 0] = user.surname + " " + user.firstname
      (1..12).each do |n|
        month=Jobmonth.where("job_id=? and month=?",job.id, Date.new(params[:year].to_i,n).beginning_of_month)
        if month[0]
           sheet[i+5, n]=month[0].workload
        end  
      end         
    end

    sheet = book.worksheet 1

    sheet[0, 1]=@project.workname
    sheet[1, 1]=params[:year]

    @jobsDPP.each_with_index do |job,i|
      user = User.find(job.user_id) 
      sheet[i+5, 0] = user.surname + " " + user.firstname
      (1..12).each do |n|
        month=Jobmonth.where("job_id=? and month=?",job.id, Date.new(params[:year].to_i,n).beginning_of_month)
        if month[0]
           sheet[i+5, n]=month[0].workload
        end  
      end         
    end


    book.write 'public/project-jobs-cache.xls'
    send_file 'public/project-jobs-cache.xls', :type => "application/vnd.ms-excel",:filename => 'PrehledUvazku_'+ @project.workname + '_' + params[:year] +".xls", :stream => false
  end
end
