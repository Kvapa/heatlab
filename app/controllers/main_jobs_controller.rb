# encoding: UTF-8
class MainJobsController < ApplicationController
  before_filter :authorize
  before_filter :authorize_admin
  # GET /main_jobs
  # GET /main_jobs.json

  def index
    @main_worklist = MainWorklist.find(params[:main_worklist_id])
    @main_jobs = @main_worklist.main_jobs.find(:all, :joins => :user, :conditions => ["users.worktype=?",0], :order=> "users.surname")
    @main_jobs_exter = @main_worklist.main_jobs.find(:all, :joins => :user, :conditions => ["users.worktype=?",1], :order=> "users.surname")



    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @main_jobs }
    end
  end

  # GET /main_jobs/1
  # GET /main_jobs/1.json
  def show
    @main_worklist = MainWorklist.find(params[:main_worklist_id])
    @main_job = MainJob.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @main_job }
    end
  end

  # GET /main_jobs/new
  # GET /main_jobs/new.json
  def new
    @main_worklist = MainWorklist.find(params[:main_worklist_id])
    @main_job = MainJob.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @main_job }
    end
  end

  # GET /main_jobs/1/edit
  def edit
    @main_worklist = MainWorklist.find(params[:main_worklist_id])
    @main_job = MainJob.find(params[:id])
  end

  # POST /main_jobs
  # POST /main_jobs.json
  def create
    @main_job = MainJob.new(params[:main_job])

    respond_to do |format|
      if @main_job.save
        format.html { redirect_to main_worklist_main_jobs_path, notice: 'Main job was successfully created.' }
        format.json { render json: @main_job, status: :created, location: @main_job }
      else
        format.html { render action: "new" }
        format.json { render json: @main_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /main_jobs/1
  # PUT /main_jobs/1.json
  def update
    @main_job = MainJob.find(params[:id])

    respond_to do |format|
      if @main_job.update_attributes(params[:main_job])
        format.html { redirect_to @main_job, notice: 'Main job was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @main_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /main_jobs/1
  # DELETE /main_jobs/1.json
  def destroy
    @main_job = MainJob.find(params[:id])
    @main_job.destroy

    respond_to do |format|
      format.html { redirect_to main_worklist_main_jobs_path }
      format.json { head :no_content }
    end
  end

  def worklist
    
    @main_worklist = MainWorklist.find(params[:main_worklist_id])
    @main_job = MainJob.find(params[:main_job_id])
    @main_month=MainJobmonth.all(
      :conditions => {
      :main_job_id =>params[:main_job_id], 
      :month => Date.new(@main_worklist.year.year,params[:month].to_i).beginning_of_month
    })
    @main_jobdays=MainJobday.all(
      :conditions => {
      :main_job_id =>params[:main_job_id], 
      :day => Date.new(@main_worklist.year.year,params[:month].to_i).beginning_of_month..Date.new(@main_worklist.year.year,params[:month].to_i).end_of_month
    }, :order => 'day ASC')
    @user = User.find( @main_job.user_id)
    @jobs_workload=view_context.main_jobs_rest_workload(@user.id,@main_worklist.year.year,params[:month].to_i)
  end

  def worklist_update
    
    @main_worklist = MainWorklist.find(params[:main_worklist_id])
    @main_job = MainJob.find(params[:main_job_id])
    @user = User.find(@main_job.user_id)
    MainJobday.update(params[:main_jobdays].keys, params[:main_jobdays].values)

    @main_jobmonth = MainJobmonth.find(params[:main_jobmonth][:id])
    if @user.worktype == 0
      @main_jobmonth.update_attribute(:workload,params[:main_jobmonth][:workload])
    end
    @main_jobmonth.update_attribute(:locked,params[:main_jobmonth][:locked])

    @jobs_workload=view_context.main_jobs_rest_workload(@user.id,@main_worklist.year.year,params[:month].to_i)
    
    days_count=0

    if params[:confirm]["change_months"] == '1'
      date_end = Date.new(@main_worklist.year.year,12.to_i).end_of_month
    else
       date_end = Date.new(@main_worklist.year.year,params[:month].to_i).end_of_month
    end

    if params[:confirm]["change_all"] == '1'
      @main_jobs=MainJobday.where('main_job_id =? AND wday = 1 AND (day >= ? AND day <= ?)', params[:main_job_id],Date.new(@main_worklist.year.year,params[:month].to_i).beginning_of_month, date_end)
      if params[:main_jobmonth][:monday] == '1'
        days_count +=1  
        @main_jobs.each  do |job|
          if job.day.holiday?(:cz)
            job.day_status = 1
          else 
            job.day_status = 2
          end
          job.save
        end
      else
        @main_jobs.each  do |job|
          job.day_status = 0
          job.save
        end 
      end

      @main_jobs=MainJobday.where('main_job_id =? AND wday = 2 AND (day >= ? AND day <= ?)', params[:main_job_id],Date.new(@main_worklist.year.year,params[:month].to_i).beginning_of_month, date_end)
      if params[:main_jobmonth][:tuesday] == '1'
        days_count +=1  
        @main_jobs.each  do |job|
          if job.day.holiday?(:cz)
            job.day_status = 1
          else 
            job.day_status = 2
          end
          job.save
        end
      else
        @main_jobs.each  do |job|
          job.day_status = 0
          job.save
        end 
      end

       @main_jobs=MainJobday.where('main_job_id =? AND wday = 3 AND (day >= ? AND day <= ?)', params[:main_job_id],Date.new(@main_worklist.year.year,params[:month].to_i).beginning_of_month, date_end)
      if params[:main_jobmonth][:wednesday] == '1'
        days_count +=1 
        @main_jobs.each  do |job|
          if job.day.holiday?(:cz)
            job.day_status = 1
          else 
            job.day_status = 2
          end
          job.save
        end
      else
        @main_jobs.each  do |job|
          job.day_status = 0
          job.save
        end  
      end

      @main_jobs=MainJobday.where('main_job_id =? AND wday = 4 AND (day >= ? AND day <= ?)', params[:main_job_id],Date.new(@main_worklist.year.year,params[:month].to_i).beginning_of_month, date_end)
      if params[:main_jobmonth][:thursday] == '1'
        days_count +=1 
        @main_jobs.each  do |job|
          if job.day.holiday?(:cz)
            job.day_status = 1
          else 
            job.day_status = 2
          end
          job.save
        end
      else
        @main_jobs.each  do |job|
          job.day_status = 0
          job.save
        end  
      end

       @main_jobs=MainJobday.where('main_job_id =? AND wday = 5 AND (day >= ? AND day <= ?)', params[:main_job_id],Date.new(@main_worklist.year.year,params[:month].to_i).beginning_of_month, date_end)
      if params[:main_jobmonth][:friday] == '1'
        days_count +=1 
        @main_jobs.each  do |job|
          if job.day.holiday?(:cz)
            job.day_status = 1
          else 
            job.day_status = 2
          end
          job.save
        end
      else
        @main_jobs.each  do |job|
          job.day_status = 0
          job.save
        end  
      end
      params[:main_jobmonth][:workdays]=days_count.to_s

      if params[:confirm]["change_months"] == '1'
        main_jobmonths=MainJobmonth.where("main_job_id=? and (month >= ? AND month <= ?)",params[:main_job_id], Date.new(@main_worklist.year.year,params[:month].to_i).beginning_of_month,date_end)
        main_jobmonths.each  do |jobm|
          jobm.workdays=params[:main_jobmonth][:workdays]
          jobm.monday=params[:main_jobmonth][:monday]
          jobm.tuesday=params[:main_jobmonth][:tuesday]
          jobm.wednesday=params[:main_jobmonth][:wednesday]
          jobm.thursday=params[:main_jobmonth][:thursday]
          jobm.friday=params[:main_jobmonth][:friday]
          jobm.save 
        end
      else
        @main_jobmonth.update_attribute(:workdays,params[:main_jobmonth][:workdays])
        @main_jobmonth.update_attribute(:monday,params[:main_jobmonth][:monday])  
        @main_jobmonth.update_attribute(:tuesday,params[:main_jobmonth][:tuesday])  
        @main_jobmonth.update_attribute(:wednesday,params[:main_jobmonth][:wednesday])  
        @main_jobmonth.update_attribute(:thursday,params[:main_jobmonth][:thursday])  
        @main_jobmonth.update_attribute(:friday,params[:main_jobmonth][:friday])  
      end

      @main_jobs=MainJobday.where('main_job_id =? AND day_status = 2 AND (day >= ? AND day <= ?)', params[:main_job_id],Date.new(@main_worklist.year.year,params[:month].to_i).beginning_of_month, date_end)
      @main_jobs.each  do |job|
        job.from=job.from.change(:hour => params[:start]["from(4i)"])
        job.until=job.until.change(:hour => params[:end]["until(4i)"])
        job.from=job.from.change(:min => params[:start]["from(5i)"])
        job.until=job.until.change(:min => params[:end]["until(5i)"])
        job.save
      end
    end
    if @user.worktype == 0
      MainJobday.where('main_job_id =? AND (day_status = 1 OR day_status = 3) AND (day >= ? AND day <= ?)', params[:main_job_id],Date.new(@main_worklist.year.year,params[:month].to_i).beginning_of_month,date_end).update_all(:hours => params[:main_jobmonth][:workload].to_f/params[:main_jobmonth][:workdays].to_f)
    else
      MainJobday.where('main_job_id =? AND (day_status = 1 OR day_status = 3) AND (day >= ? AND day <= ?)', params[:main_job_id],Date.new(@main_worklist.year.year,params[:month].to_i).beginning_of_month,date_end).update_all(:hours =>  @jobs_workload.to_f/params[:main_jobmonth][:workdays].to_f)
    end

    flash[:notice] = "Uloženo"
    redirect_to main_worklist_main_job_path(@main_worklist,@main_job)+"/worklist/"+params[:month]
  end

  def export_xls
    @main_worklist = MainWorklist.find(params[:main_worklist_id])
    @main_job = MainJob.find(params[:main_job_id])
    @user = User.find(@main_job.user_id) 
    @main_month=MainJobmonth.all( 
      :conditions => {
      :main_job_id =>params[:main_job_id], 
      :month => Date.new(@main_worklist.year.year,params[:month].to_i).beginning_of_month
    })
    @main_jobdays=MainJobday.all(
      :conditions => {
      :main_job_id =>params[:main_job_id], 
      :day => Date.new(@main_worklist.year.year,params[:month].to_i).beginning_of_month..Date.new(@main_worklist.year.year,params[:month].to_i).end_of_month
    }, :order => 'day ASC')

    require 'spreadsheet'
    Spreadsheet.client_encoding = 'UTF-8'    
    book = Spreadsheet.open 'public/heatlab.xls'
    sheet = book.worksheet 0

    wdays = {0 => "Ne", 1 => "Po", 2 => "Út",3 => "St", 4 => "Čt",5 => "Pá", 6 => "So"}
    months = {1 => "Leden", 2 => "Únor", 3 => "Březen", 4 => "Duben", 5 => "Květen", 6 => "Červen",
                 7 => "Červenec", 8 => "Srpen", 9 => "Září", 10 => "Říjen", 11 => "Listopad", 12 => "Prosinec"}
    work_status = {0 => "Nepracovní den", 1 => "Svátek", 3 => "Dovolená", 4 => "Nemoc"}
    @holiday = 1
    @sick = 1
    sheet[0, 2] = @user.personal_number
    sheet[0, 11] = @user.firstname + ' ' + @user.surname
    @main_jobdays.each_with_index do |jobday,index|
      sheet[3+index, 0] = (jobday.day).strftime("%d.%m.%Y")
      sheet[3+index, 1] = wdays[jobday.day.wday]
      
      case jobday.day_status
      
        when 1  
          sheet[3+index, 2] = "Svátek"  
        when 2
          sheet[3+index, 3] = jobday.from 
          sheet[3+index, 4] = jobday.until
        when 3
          sheet[3+index, 10] = @holiday
          @holiday +=1
        when 4
          sheet[3+index, 8] = @sick
          @sick +=1
        when 5
          sheet[3+index, 3] = jobday.from 
          sheet[3+index, 4] = jobday.until
          sheet[3+index, 9] = jobday.trip_town
      end
    end


    book.write 'public/heatlab-cache.xls'
    send_file 'public/heatlab-cache.xls', :type => "application/vnd.ms-excel", :filename => @user.surname + "_" + @main_worklist.year.year.to_s + "-" + months[params[:month].to_i] +".xls", :stream => false  
  end

  def jobcheck
    @main_worklist = MainWorklist.find(params[:main_worklist_id])
    @main_job = MainJob.find(params[:main_job_id]) 
    @user=User.find(@main_job.user_id)
    @projects=User.find(@main_job.user_id).projects.uniq
    @jobs=[]
    @projects.each do |p|
      jobss=Job.where("project_id=? and user_id=?",p.id,@user.id)
      jobss.each do |j|
        @jobs.push(j)
      end
    end 
  end

  def jobcheck_update
    @main_worklist = MainWorklist.find(params[:main_worklist_id])
    @main_job = MainJob.find(params[:main_job_id]) 
    @user=User.find(@main_job.user_id)
    @projects=User.find(@main_job.user_id).projects.uniq
    @jobs=[]
    @projects.each do |p|
      jobss=Job.where("project_id=? and user_id=?",p.id,@user.id)
      jobss.each do |j|
        @jobs.push(j)
      end
    end  

    if numeric?(params[:heatlab]["hours"])
      params[:heatlab].each_with_index do |a,i| 
        if i<params[:heatlab].size-1 
          if a[1] == "1"
            if params["heatlab"]["change_all"] == "1"
              main_jobmonths=MainJobmonth.where("main_job_id=? and month >= ?",params[:main_job_id],Date.new(@main_worklist.year.year,a[0].to_i).beginning_of_month)
              main_jobmonths.each do |job|
                job.update_attribute(:workload,params[:heatlab][:hours].to_f)            
              end 
            else
              main_jobmonth=MainJobmonth.where("main_job_id=? and month=?",params[:main_job_id],Date.new(@main_worklist.year.year,a[0].to_i).beginning_of_month)
              main_jobmonth[0].update_attribute(:workload,params[:heatlab][:hours].to_f)
            end
          end
        end
      end
    end

    @jobs.each do |j|
      if numeric?(params[j.id.to_s]["hours"])
        params[j.id.to_s].each_with_index do |a,i| 
          if i<params[j.id.to_s].size-1 
            if a[1] == "1"
              if params[j.id.to_s]["change_all"] == "1"
                jobmonths=Jobmonth.where("job_id=? and month >= ? ",j.id, Date.new(@main_worklist.year.year,a[0].to_i).beginning_of_month)
                jobmonths.each do |job|
                  job.update_attribute(:workload,params[j.id.to_s][:hours].to_f)    
                end       
              else 
                jobmonth=Jobmonth.where("job_id=? and month=?",j.id, Date.new(@main_worklist.year.year,a[0].to_i).beginning_of_month) 
                jobmonth[0].update_attribute(:workload,params[j.id.to_s][:hours].to_f)
              end
            end
          end
        end
      end
    end

  redirect_to  main_worklist_main_job_jobcheck_path(@main_worklist,@main_job)
  end
  def numeric?(object)
    true if Float(object) rescue false
  end
end

