#encoding: utf-8
class JobsController < ApplicationController
  before_filter :authorize
  before_filter :authorize_admin, :except => [:worklist_autocomplete, :export_xls]
  include ActionView::Helpers::NumberHelper

  # GET /jobs
  # GET /jobs.json
  def index
    @project = Project.find(params[:project_id])
    #@jobs = @project.jobs.find(:all, :joins => :user,:conditions => ["users.worktype=?",0], :order=> "users.surname")
    #@jobsDPP = @project.jobs.find(:all, :joins => :user,:conditions => ["users.worktype=?",1], :order=> "users.surname")
    @jobs = @project.jobs.find(:all, :joins => :user,:conditions => ["usertype=?",0], :order=> "users.surname")
    @jobsDPP = @project.jobs.find(:all, :joins => :user,:conditions => ["usertype=?",1], :order=> "users.surname")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @jobs }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @project = Project.find(params[:project_id])
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.json
  def new
    @project = Project.find(params[:project_id])
    @job = Job.new
    @job.projectid=params[:project_id]
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job }
    end
  end

  # GET /jobs/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @job = Job.find(params[:id])
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @project = Project.find(params[:project_id])
    @job = Job.new(params[:job])

    @job.dpp_days = Array.new(7)
    @job.dpp_days[0] = 0
    @job.dpp_days[1] = params[:dpp][:monday] == '1' ? 1 : 0
    @job.dpp_days[2] = params[:dpp][:tuesday] == '1' ? 1 : 0
    @job.dpp_days[3] = params[:dpp][:wednesday] == '1' ? 1 : 0
    @job.dpp_days[4] = params[:dpp][:thursday] == '1' ? 1 : 0
    @job.dpp_days[5] = params[:dpp][:friday] == '1' ? 1 : 0
    @job.dpp_days[6] = 0

    respond_to do |format|
      if @job.save
        format.html { redirect_to project_jobs_path, notice: 'Úvazek byl úspěšně vytvořen.' }
        format.json { render json: @job, status: :created, location: @job }
      else
        format.html { render action: "new" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.json
  def update
    @project = Project.find(params[:project_id])
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to project_jobs_path, notice: 'Úvazek byl úspěšně změněn.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @project = Project.find(params[:project_id])
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to project_jobs_path}
      format.json { head :no_content }
    end
  end
  def worklist
    @project = Project.find(params[:project_id])
    @job = Job.find(params[:job_id])
    @user=User.find(@job.user_id)
    @main_worklist=MainWorklist.where("year=?",Date.new(params[:year].to_i,1,1))  

    if !@main_worklist.blank?
      @main_job=MainJob.where("main_worklist_id=? AND user_id=?", @main_worklist[0].id, @job.user_id.to_s)
    end

    if !@main_job.blank?
      @main_jobmonth=MainJobmonth.where("main_job_id = ? AND month=?", @main_job[0].id, Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month)
      @main_jobdays=MainJobday.all(
        :conditions => {
        :main_job_id => @main_job[0].id, 
        :day => Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month..Date.new(params[:year].to_i,params[:month].to_i).end_of_month
        })
    end
    @month=Jobmonth.all(
      :conditions => {
      :job_id =>params[:job_id], 
      :month => Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month
    })
    @jobdays=Jobday.all(
      :conditions => {
      :job_id =>params[:job_id], 
      :day => Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month..Date.new(params[:year].to_i,params[:month].to_i).end_of_month
    },:order => 'day ASC')
    

    @events = Event.where("(day BETWEEN ? AND ?) OR (date_until BETWEEN ? AND ?) ", Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month, Date.new(params[:year].to_i,params[:month].to_i).end_of_month,Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month, Date.new(params[:year].to_i,params[:month].to_i).end_of_month)
    
    #require 'spreadsheet'
    #Spreadsheet.client_encoding = 'UTF-8'    
    #book = Spreadsheet.open 'public/test2.xls'
    #sheet = book.worksheet 0
    #sheet[3, 4] = "test"
    #book.write 'public/test.xls'
    #send_file 'public/test.xls', :type => "application/vnd.ms-excel", :filename => "test.xls", :stream => false
    @sum_hours = 0.0
    Jobday.where('job_id =? AND (day_status = 1 OR day_status = 2 OR day_status = 3 OR day_status = 4 or day_status = 5) AND (day >= ? AND day <= ?)', params[:job_id], Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month,Date.new(params[:year].to_i,params[:month].to_i).end_of_month).each do |day|
      if !day.hours.blank?
        @sum_hours += day.hours
      end
    end
  end

  def worklist_update
    @project = Project.find(params[:project_id])
    @job = Job.find(params[:job_id])

    Jobday.update(params[:jobdays].keys, params[:jobdays].values)

    @jobmonth = Jobmonth.find(params[:jobmonth][:id])
    @jobmonth.update_attribute(:workload,params[:jobmonth][:workload])
    @jobmonth.update_attribute(:filled,params[:jobmonth][:filled])
    @jobmonth.update_attribute(:checked,params[:jobmonth][:checked])

    if params[:confirm]["change_months"] == '1'
      date_end = @project.end_date
    else
       date_end = Date.new(@project.end_date.year,params[:month].to_i).end_of_month
    end

    days_count=0

    if params[:confirm]["change_all"] == '1'
      @jobs=Jobday.where('job_id =? AND wday = 1 AND (day >= ? AND day <= ?)', params[:job_id],Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month,date_end)
      if params[:jobmonth][:monday] == '1'
        days_count +=1  
        @jobs.each  do |job|
          if job.day.holiday?(:cz)
            job.day_status = 1
          else 
            job.day_status = 2
          end
          job.save
        end
      else
        @jobs.each  do |job|
          job.day_status = 0
          job.save
        end 
      end

      @jobs=Jobday.where('job_id =? AND wday = 2 AND (day >= ? AND day <= ?)', params[:job_id],Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month,date_end)
      if params[:jobmonth][:tuesday] == '1'
        days_count +=1  
        @jobs.each  do |job|
          if job.day.holiday?(:cz)
            job.day_status = 1
          else 
            job.day_status = 2
          end
          job.save
        end
      else
        @jobs.each  do |job|
          job.day_status = 0
          job.save
        end 
      end

      @jobs=Jobday.where('job_id =? AND wday = 3 AND (day >= ? AND day <= ?)', params[:job_id],Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month,date_end)
      if params[:jobmonth][:wednesday] == '1'
        days_count +=1  
        @jobs.each  do |job|
          if job.day.holiday?(:cz)
            job.day_status = 1
          else 
            job.day_status = 2
          end
          job.save
        end
      else
        @jobs.each  do |job|
          job.day_status = 0
          job.save
        end 
      end

      @jobs=Jobday.where('job_id =? AND wday = 4 AND (day >= ? AND day <= ?)', params[:job_id],Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month,date_end)
      if params[:jobmonth][:thursday] == '1'
        days_count +=1  
        @jobs.each  do |job|
          if job.day.holiday?(:cz)
            job.day_status = 1
          else 
            job.day_status = 2
          end
          job.save
        end
      else
        @jobs.each  do |job|
          job.day_status = 0
          job.save
        end 
      end

      @jobs=Jobday.where('job_id =? AND wday = 5 AND (day >= ? AND day <= ?)', params[:job_id],Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month,date_end)
      if params[:jobmonth][:friday] == '1'
        days_count +=1  
        @jobs.each  do |job|
          if job.day.holiday?(:cz)
            job.day_status = 1
          else 
            job.day_status = 2
          end
          job.save
        end
      else
        @jobs.each  do |job|
          job.day_status = 0
          job.save
        end 
      end

      params[:jobmonth][:workdays]=days_count

      @jobmonth.update_attribute(:workdays,params[:jobmonth][:workdays])
      @jobmonth.update_attribute(:monday,params[:jobmonth][:monday])  
      @jobmonth.update_attribute(:tuesday,params[:jobmonth][:tuesday])  
      @jobmonth.update_attribute(:wednesday,params[:jobmonth][:wednesday])  
      @jobmonth.update_attribute(:thursday,params[:jobmonth][:thursday])  
      @jobmonth.update_attribute(:friday,params[:jobmonth][:friday])  

      if @job.usertype == 0  
        hours = params[:jobmonth][:workload].to_f/params[:jobmonth][:workdays].to_f   
      else
       hours = 0
      end

      Jobday.where('job_id =? AND (day_status = 1 OR day_status = 2 OR day_status = 3 OR day_status = 4) AND (day >= ? AND day <= ?)', params[:job_id], Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month,date_end).update_all(:hours => hours.to_f)
    end

    flash[:notice] = "Uloženo!"
    redirect_to project_job_path(@project,@job)+"/worklist/"+params[:year]+"/"+params[:month]
  end

  def worklist_autocomplete
    @project = Project.find(params[:project_id])
    @job = Job.find(params[:job_id])
    @position=ProjectPosition.find(@job[:position])   
    if @project.xls ==2
      render json: ["název činnosti|popis vykonaných aktivit"].concat(@position.project_activities.order("position").map(&:description)) 
    else
      render json: @position.project_activities.order("position").map(&:description)
    end
  end


  def export_xls
    @project = Project.find(params[:project_id])
    @job = Job.find(params[:job_id])
    @user = User.find(@job.user_id)
    @jobmonth=Jobmonth.all(
      :conditions => {
      :job_id =>params[:job_id], 
      :month => Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month
    })
    @main_worklist=MainWorklist.where("year=?",Date.new(params[:year].to_i,1,1))

    if !@main_worklist.blank?
      @main_job=MainJob.where("main_worklist_id=? AND user_id=?", @main_worklist[0].id, @job.user_id.to_s)
    end

    if !@main_job.blank?
      @main_jobmonth=MainJobmonth.where("main_job_id = ? AND month=?", @main_job[0].id, Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month)
    end
    
    @jobdays=Jobday.all(
      :conditions => {
      :job_id =>params[:job_id], 
      :day => Date.new(params[:year].to_i,params[:month].to_i).beginning_of_month..Date.new(params[:year].to_i,params[:month].to_i).end_of_month
    },:order => 'day ASC')

    workloads=view_context.jobs_rest_workload(@job.id,params[:year].to_i,params[:month].to_i)

    @sum_hours = 0
    @jobdays.each do |day|
      @sum_hours += day.hours  
    end


    if @project.id == 8
      require 'spreadsheet'
      Spreadsheet.client_encoding = 'UTF-8' 
      
      if @job.position == 45
        book = Spreadsheet.open 'public/postdoc-mentor.xls'    

        @holiday_days="";
        @holiday_count=0;
        @holiday_hours=0;

        @sick_days="";
        @sick_count=0;
        @sick_hours=0;

        sheet = book.worksheet 0
        wdays = {0 => "neděle", 1 => "pondělí", 2 => "úterý",3 => "středa", 4 => "čtvrtek",5 => "pátek", 6 => "sobota"}
        months = {1 => "Leden", 2 => "Únor", 3 => "Březen", 4 => "Duben", 5 => "Květen", 6 => "Červen",
                     7 => "Červenec", 8 => "Srpen", 9 => "Září", 10 => "Říjen", 11 => "Listopad", 12 => "Prosinec"}
        work_status = {0 => "Nepracovní den", 1 => "Svátek", 3 => "Dovolená", 4 => "Nemoc"}

        sheet[4, 4] = @project.number
        sheet[5, 4] = @project.name

        sheet[9, 3] = User.find(@job.user_id).fullname
        sheet[10, 3] = ProjectPosition.find(@job.position).name.gsub(/\(.*?\)/, '')
        sheet[11, 3] = months[params[:month].to_i] +" "+ params[:year]

        sheet[10, 8] = @sum_hours

        @jobdays.each_with_index do |jobday,index|
        sheet[16+index, 1] = wdays[jobday.day.wday]
       
        
        if  jobday.day_status == 0 || jobday.day_status == 1 || jobday.day_status == 3 || jobday.day_status == 4
          sheet[16+index, 3] = work_status[jobday.day_status]
          if jobday.day_status == 3
            if @holiday_days ==""
              @holiday_days += jobday.day.day.to_s
              @holiday_count +=1;
              @holiday_hours +=jobday.hours
            else
              @holiday_days += ", " + jobday.day.day.to_s
              @holiday_count +=1;
              @holiday_hours +=jobday.hours
            end
          end
          if jobday.day_status == 4
            if @sick_days ==""
              @sick_days += jobday.day.day.to_s
              @sick_count +=1;
              @sick_hours +=jobday.hours
            else
              @sick_days += ", " + jobday.day.day.to_s
              @sick_count +=1;
              @sick_hours +=jobday.hours
            end
          end
          if jobday.day_status == 1
            sheet[16+index, 2] = jobday.hours.to_f  
          end
        else
          sheet[16+index, 3] = jobday.description
          sheet[16+index, 2] = jobday.hours.to_f
        end
        sheet[50, 3]= @holiday_days
        sheet[51, 3]= @holiday_count
        sheet[52, 3]= @holiday_count 
        sheet[53, 3]= @holiday_hours

        sheet[50, 7]= @sick_days
        sheet[51, 7]= @sick_count
        sheet[52, 7]= @sick_count * 8
        sheet[53, 7]= @sick_hours

      end 
    end

    book.write 'public/postdoc-cache.xls'
    send_file 'public/postdoc-cache.xls', :type => "application/vnd.ms-excel",:filename => @project.workname + "_" + User.find(@job.user_id).surname + "_" + params[:year] + "-" + months[params[:month].to_i] +".xls", :stream => false

    elsif @project.xls == 1
      require 'spreadsheet'
      Spreadsheet.client_encoding = 'UTF-8'    
      if @job.usertype == 0 
        book = Spreadsheet.open 'public/denni.xls'
      else book = Spreadsheet.open 'public/denniDPP.xls'
      end
      sheet = book.worksheet 0
      wdays = {0 => "Ne", 1 => "Po", 2 => "Út",3 => "St", 4 => "Čt",5 => "Pá", 6 => "So"}
      months = {1 => "Leden", 2 => "Únor", 3 => "Březen", 4 => "Duben", 5 => "Květen", 6 => "Červen",
                   7 => "Červenec", 8 => "Srpen", 9 => "Září", 10 => "Říjen", 11 => "Listopad", 12 => "Prosinec"}
      work_status = {0 => "Nepracovní den", 1 => "Svátek", 3 => "Dovolená", 4 => "Nemoc"}

      sheet[3, 4] = @project.number
      sheet[4, 4] = @project.name
      sheet[5, 4] = "Vysoké učení technické v Brně"
      sheet[8, 3] = User.find(@job.user_id).fullname
      sheet[9, 3] = ProjectPosition.find(@job.position).name.gsub(/\(.*?\)/, '')
      sheet[10, 3] = ProjectPosition.find(@job.position).position_number
      sheet[11, 3] = months[params[:month].to_i] +" "+ params[:year]
      if @job.usertype == 0
        sheet[8, 8] = "pracovní smlouva"
      else 
        if @job.position == 30 || @job.position == 19
          sheet[8, 8] = "dohoda o pracovní činnosti"
        else 
          sheet[8, 8] = "dohoda o provedení práce"
        end
      end

      @holiday_days="";
      @holiday_count=0;
      @holiday_hours=0;

      @sick_days="";
      @sick_count=0;
      @sick_hours=0;

      if @jobmonth[0].workload <5
        if @job.usertype == 0
          sheet[9, 8] = (@jobmonth[0].workload.to_f/40).round(2)
        else
          sheet[9, 8] = @jobmonth[0].workload.to_s + ' hodiny/měsíčně'
        end
      else
        if @job.usertype == 0
          sheet[9, 8] = (@jobmonth[0].workload.to_f/40).round(2) 
          else
          sheet[9, 8] = @jobmonth[0].workload.to_s + ' hodin/měsíčně'
        end
      end
      if @job.usertype == 0 && @job.joined
          sheet[11, 8] =  ((workloads[0]-@jobmonth[0].workload).to_f/40).round(2)
      else 
        sheet[11, 8] = '0'
      end
      @jobdays.each_with_index do |jobday,index|
        sheet[15+index, 1] = wdays[jobday.day.wday]
       
        
        if  jobday.day_status == 0 || jobday.day_status == 1 || jobday.day_status == 3 || jobday.day_status == 4
          sheet[15+index, 3] = work_status[jobday.day_status]
          if jobday.day_status == 3
            if @holiday_days ==""
              @holiday_days += jobday.day.day.to_s
              @holiday_count +=1;
              @holiday_hours +=jobday.hours
            else
              @holiday_days += ", " + jobday.day.day.to_s
              @holiday_count +=1;
              @holiday_hours +=jobday.hours
            end
          end
          if jobday.day_status == 4
            if @sick_days ==""
              @sick_days += jobday.day.day.to_s
              @sick_count +=1;
              @sick_hours +=jobday.hours
            else
              @sick_days += ", " + jobday.day.day.to_s
              @sick_count +=1;
              @sick_hours +=jobday.hours
            end
          end
          if jobday.day_status == 1
            sheet[15+index, 2] = jobday.hours.to_f  
          end
        else
          sheet[15+index, 3] = jobday.description
          sheet[15+index, 2] = jobday.hours.to_f
        end
          

      end  

      if @job.usertype == 0

        if !@job.joined
          ratio = 1
        else
          ratio = @main_jobmonth[0].workload.to_f / 40
          if ratio > 1
            ratio = 1
          end
        end

        sheet[49, 3]= @holiday_days
        sheet[50, 3]= @holiday_count
        sheet[51, 3]= @holiday_count * 8 * ratio
        sheet[52, 3]= @holiday_hours

        sheet[49, 7]= @sick_days
        sheet[50, 7]= @sick_count
        sheet[51, 7]= @sick_count * 8
        sheet[52, 7]= @sick_hours
      end

      sheet[57, 3]= (Date.new(params[:year].to_i,params[:month].to_i).end_of_month).strftime("%d.%m.%Y")
      sheet[57, 8]= (Date.new(params[:year].to_i,params[:month].to_i).end_of_month).strftime("%d.%m.%Y")
      

      book.write 'public/denni-cache.xls'
      send_file 'public/denni-cache.xls', :type => "application/vnd.ms-excel",:filename => @project.workname + "_" + User.find(@job.user_id).surname + "_" + params[:year] + "-" + months[params[:month].to_i] +".xls", :stream => false    
    

    elsif @project.xls == 2
      require 'spreadsheet'
      Spreadsheet.client_encoding = 'UTF-8'
      if @project.id == 9
        book = Spreadsheet.open 'public/netme-center.xls'
      else      
        book = Spreadsheet.open 'public/souhrnny.xls'
      end

      sheet = book.worksheet 0
      wdays = {0 => "Ne", 1 => "Po", 2 => "Út",3 => "St", 4 => "Čt",5 => "Pá", 6 => "So"}
      months = {1 => "Leden", 2 => "Únor", 3 => "Březen", 4 => "Duben", 5 => "Květen", 6 => "Červen",
                   7 => "Červenec", 8 => "Srpen", 9 => "Září", 10 => "Říjen", 11 => "Listopad", 12 => "Prosinec"}
      work_status = {0 => "Nepracovní den", 1 => "Svátek", 3 => "Dovolená", 4 => "Nemoc"}

      sheet[6, 2] = @project.number
      sheet[7, 2] = @project.name
      sheet[8, 2] = "Vysoké učení technické v Brně"
      sheet[10, 2] = User.find(@job.user_id).fullname
      sheet[10, 6] = "ZS"
      sheet[12, 2] = ProjectPosition.find(@job.position).name
      if @job.id == 54
        sheet[11, 2] = "odborný"
      else
        sheet[11, 2] = "výzkumný"
      end
      sheet[11, 6] = @jobmonth[0].workload.to_f / 40
      sheet[12, 6] = params[:month] + "/" + params[:year]

      holiday_days=""
      holiday_count=0
      holiday_hours=0

      sick_days=""
      sick_count=0
      sick_hours=0

      pub_day = 0

      days=[]
      @jobdays.each_with_index do |jobday,index|
        if (jobday.day_status == 2 || jobday.day_status == 5)  && jobday.description != "" 
            days.push(jobday.description)

        elsif jobday.day_status == 3
          if holiday_days ==""
            holiday_days += jobday.day.day.to_s
            holiday_count +=1
            holiday_hours +=jobday.hours
          else
            holiday_days += ", " + jobday.day.day.to_s
            holiday_count +=1
            holiday_hours +=jobday.hours
          end
        elsif jobday.day_status == 4
          if sick_days ==""
            sick_days += jobday.day.day.to_s
            sick_count +=1
            sick_hours +=jobday.hours
          else
            sick_days += ", " + jobday.day.day.to_s
            sick_count +=1
            sick_hours +=jobday.hours
          end
        elsif jobday.day_status == 1
          pub_day += 8 * @jobmonth[0].workload.to_f / 40 * 5 / @jobmonth[0].workdays.to_f  
        end 
      end  
      res=Hash[days.group_by {|x| x}.map {|k,v| [k,v.count]}]
      res=res.sort_by {|k,v| v}.reverse

      hours_sum = 0
      res.each_with_index do |x,i|
        hours_sum += x[1] * @jobmonth[0].workload.to_f / @jobmonth[0].workdays.to_f
        sheet[24+i, 0] = x[1] * @jobmonth[0].workload.to_f / @jobmonth[0].workdays.to_f
        y = x[0].split("|")

        sheet[24+i, 1] = y[0]
        sheet[24+i, 3] = y[1]
      end

      if @project.id == 9
        sheet[37, 0] = pub_day
        sheet[39, 1] = hours_sum + pub_day

        sheet[42, 2] = holiday_days
        sheet[43, 2] = holiday_count
        sheet[44, 2] = holiday_hours

        sheet[42, 6] = sick_days
        sheet[43, 6] = sick_count
        sheet[44, 6] = sick_hours
      else  
        sheet[42, 0] = pub_day
        sheet[44, 1] = hours_sum + pub_day

        sheet[47, 2] = holiday_days
        sheet[48, 2] = holiday_count
        sheet[49, 2] = holiday_hours

        sheet[47, 6] = sick_days
        sheet[48, 6] = sick_count
        sheet[49, 6] = sick_hours
      end

      if @project.id == 9
        sheet[53, 4] = User.find(@job.user_id).firstname + " " + User.find(@job.user_id).surname
        sheet[53, 5] = ProjectPosition.find(@job.position).name
        sheet[53, 3] = @jobmonth[0].month.end_of_month.strftime("%d.%m.%Y")  
        sheet[54, 3] = @jobmonth[0].month.end_of_month.strftime("%d.%m.%Y") 
        sheet[54, 4] = 'Peregrína Štípová'
        sheet[54, 5] = 'výkonná ředitelka'
      
      else
        sheet[58, 4] = User.find(@job.user_id).firstname + " " + User.find(@job.user_id).surname
        sheet[58, 5] = ProjectPosition.find(@job.position).name
        sheet[58, 3] = @jobmonth[0].month.end_of_month.strftime("%d.%m.%Y")
        sheet[59, 3] = @jobmonth[0].month.end_of_month.strftime("%d.%m.%Y")

        if @job.user_id == 2
          sheet[59, 4] = "Jaroslav Horský"
          sheet[59, 5] = "vedoucí pracoviště"
        else  
          sheet[59, 4] = "Miroslav Raudenský"
          sheet[59, 5] = "garant"
        end
      end
      

      book.write 'public/souhrnny-cache.xls'
      send_file 'public/souhrnny-cache.xls', :type => "application/vnd.ms-excel",:filename => @project.workname + "_" + User.find(@job.user_id).surname + "_" + params[:year] + "-" + months[params[:month].to_i] +".xls", :stream => false    

    elsif @project.xls == 3
      require 'spreadsheet'
      Spreadsheet.client_encoding = 'UTF-8'
  
      book = Spreadsheet.open 'public/tacr.xls'
      

      sheet = book.worksheet 0
      wdays = {0 => "Ne", 1 => "Po", 2 => "Út",3 => "St", 4 => "Čt",5 => "Pá", 6 => "So"}
      months = {1 => "Leden", 2 => "Únor", 3 => "Březen", 4 => "Duben", 5 => "Květen", 6 => "Červen",
                   7 => "Červenec", 8 => "Srpen", 9 => "Září", 10 => "Říjen", 11 => "Listopad", 12 => "Prosinec"}
      work_status = {0 => "Nepracovní den", 1 => "Svátek", 3 => "Dovolená", 4 => "Nemoc"}

      sheet[2, 4] = @project.number
      sheet[3, 4] = @project.name
      sheet[4, 1] = User.find(@job.user_id).fullname
      sheet[5, 1] = months[params[:month].to_i]
      sheet[6, 1] = params[:year]
      sheet[8, 4] = ProjectPosition.find(@job.position).name

      holiday_days=""
      holiday_count=0
      holiday_hours=0

      sick_days=""
      sick_count=0
      sick_hours=0

      pub_day = 0

      days=[]
      @jobdays.each_with_index do |jobday,index|
        if (jobday.day_status == 2 || jobday.day_status == 5)  && jobday.description != "" 
            days.push(jobday.description)

        elsif jobday.day_status == 3
          if holiday_days ==""
            holiday_days += jobday.day.day.to_s
            holiday_count +=1
            holiday_hours +=jobday.hours
          else
            holiday_days += ", " + jobday.day.day.to_s
            holiday_count +=1
            holiday_hours +=jobday.hours
          end
        elsif jobday.day_status == 4
          if sick_days ==""
            sick_days += jobday.day.day.to_s
            sick_count +=1
            sick_hours +=jobday.hours
          else
            sick_days += ", " + jobday.day.day.to_s
            sick_count +=1
            sick_hours +=jobday.hours
          end
        elsif jobday.day_status == 1
          pub_day += 8 * @jobmonth[0].workload.to_f / 40 * 5 / @jobmonth[0].workdays.to_f  
        end 
      end 

      sum_pub = 0
      sum_pubday = 0
      sum_work = 0
      sum_workday = 0
      sum_sick = 0
      sum_sickday = 0
      sum_holi = 0
      sum_holiday = 0

      @jobdays.each do |day|
        if day.day_status == 1
          sum_pub += day.hours
          sum_pubday += 1
        end

        if day.day_status == 2
          sum_work += day.hours
          sum_workday += 1
        end

        if day.day_status == 3
          sum_holi += day.hours
          sum_holiday += 1
        end

        if day.day_status == 4
          sum_sick += day.hours
          sum_sickday += 1
        end 
      end 

      t=""
      res=Hash[days.group_by {|x| x}.map {|k,v| [k,v.count]}]
      res=res.sort_by {|k,v| v}.reverse

      hours_sum = 0
      res.each_with_index do |x,i|
        t=t+x[0]+"\n"
      end
 
      sheet[9, 0] = t

      sheet[10, 4] =  sum_pub + sum_work 

      sheet[14, 4] = sum_holiday
      sheet[15, 4] = sum_holi

      sheet[18, 4] = sum_sickday
      sheet[19, 4] = sum_sick

      sheet[24, 4] = @jobmonth[0].month.end_of_month.strftime("%d.%m.%Y")
      sheet[29, 4] = @jobmonth[0].month.end_of_month.strftime("%d.%m.%Y")

      if @job.user_id == 12
        sheet[30, 4] = "Miroslav Raudenský"
        sheet[31, 4] = "vědecký pracovník"
      else 
        sheet[30, 4] = "Jaroslav Horský"
        sheet[31, 4] = "řešitel"  
      end
      book.write 'public/tacr-cache.xls'
      send_file 'public/tacr-cache.xls', :type => "application/vnd.ms-excel", :filename => @project.workname + "_" + User.find(@job.user_id).surname + "_" + params[:year] + "-" + months[params[:month].to_i] +".xls", :stream => false    
     
     elsif @project.xls == 4
      require 'spreadsheet'
      Spreadsheet.client_encoding = 'UTF-8'
  
      book = Spreadsheet.open 'public/uhli.xls'
      

      sheet = book.worksheet 0
      wdays = {0 => "Ne", 1 => "Po", 2 => "Út",3 => "St", 4 => "Čt",5 => "Pá", 6 => "So"}
      months = {1 => "Leden", 2 => "Únor", 3 => "Březen", 4 => "Duben", 5 => "Květen", 6 => "Červen",
                   7 => "Červenec", 8 => "Srpen", 9 => "Září", 10 => "Říjen", 11 => "Listopad", 12 => "Prosinec"}
      work_status = {0 => "Nepracovní den", 1 => "Svátek", 3 => "Dovolená", 4 => "Nemoc"}

      sheet[2, 4] = @project.number
      sheet[3, 4] = @project.name
      sheet[4, 1] = User.find(@job.user_id).fullname
      sheet[5, 1] = months[params[:month].to_i]
      sheet[6, 1] = params[:year]
      sheet[8, 4] = ProjectPosition.find(@job.position).name

      holiday_days=""
      holiday_count=0
      holiday_hours=0

      sick_days=""
      sick_count=0
      sick_hours=0

      pub_day = 0

      days=[]
      @jobdays.each_with_index do |jobday,index|
        if (jobday.day_status == 2 || jobday.day_status == 5)  && jobday.description != "" 
            days.push(jobday.description)

        elsif jobday.day_status == 3
          if holiday_days ==""
            holiday_days += jobday.day.day.to_s
            holiday_count +=1
            holiday_hours +=jobday.hours
          else
            holiday_days += ", " + jobday.day.day.to_s
            holiday_count +=1
            holiday_hours +=jobday.hours
          end
        elsif jobday.day_status == 4
          if sick_days ==""
            sick_days += jobday.day.day.to_s
            sick_count +=1
            sick_hours +=jobday.hours
          else
            sick_days += ", " + jobday.day.day.to_s
            sick_count +=1
            sick_hours +=jobday.hours
          end
        elsif jobday.day_status == 1
          pub_day += 8 * @jobmonth[0].workload.to_f / 40 * 5 / @jobmonth[0].workdays.to_f  
        end 
      end 

      sum_pub = 0
      sum_pubday = 0
      sum_work = 0
      sum_workday = 0
      sum_sick = 0
      sum_sickday = 0
      sum_holi = 0
      sum_holiday = 0

      @jobdays.each do |day|
        if day.day_status == 1
          sum_pub += day.hours
          sum_pubday += 1
        end

        if day.day_status == 2
          sum_work += day.hours
          sum_workday += 1
        end

        if day.day_status == 3
          sum_holi += day.hours
          sum_holiday += 1
        end

        if day.day_status == 4
          sum_sick += day.hours
          sum_sickday += 1
        end 
      end 

      t=""
      res=Hash[days.group_by {|x| x}.map {|k,v| [k,v.count]}]
      res=res.sort_by {|k,v| v}.reverse

      hours_sum = 0
      res.each_with_index do |x,i|
        t=t+x[0]+"\n"
      end
 
      sheet[9, 0] = t

      sheet[10, 4] =  sum_pub + sum_work 

      sheet[14, 4] = sum_holiday
      sheet[15, 4] = sum_holi

      sheet[18, 4] = sum_sickday
      sheet[19, 4] = sum_sick

      sheet[24, 4] = @jobmonth[0].month.end_of_month.strftime("%d.%m.%Y")
      sheet[29, 4] = @jobmonth[0].month.end_of_month.strftime("%d.%m.%Y")

      book.write 'public/uhli-cache.xls'
      send_file 'public/uhli-cache.xls', :type => "application/vnd.ms-excel", :filename => @project.workname + "_" + User.find(@job.user_id).surname + "_" + params[:year] + "-" + months[params[:month].to_i] +".xls", :stream => false    
    
    end
  end
end
