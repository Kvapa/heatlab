class Job < ActiveRecord::Base
  attr_accessible :project_id, :user_id,  :position, :hours_per_week, :start_date, :end_date, :joined, :contract, :usertype, :start_date_proper, :end_date_proper 
  attr_accessor :dpp_days, :projectid
  validates :position, :numericality => { :only_integer => true }
  validates :user_id, :numericality => { :only_integer => true }
  validates :hours_per_week, :numericality => { :greater_than_or_equal_to => 0 }
  after_create :create_workdays

  belongs_to :user
  belongs_to :project
  has_many :jobdays, :dependent => :delete_all 
  has_many :jobmonths, :dependent => :delete_all 


  def create_workdays	
  	@project = Project.find(self.project_id)
  	(@project.start_date..@project.end_date).each do |day|
      if day == day.beginning_of_month
        test=Jobmonth.new
        test.job_id = self.id
        test.month=day
        test.workload=self.hours_per_week
        test.save
      end
  		test=Jobday.new
  		test.job_id = self.id
  		test.day=day
      test.wday=day.wday
      if day.wday == 0 || day.wday == 6
        test.day_status = 0
      elsif day.holiday?(:cz)
        test.day_status = 1
        if self.usertype == 1
          test.day_status = 0    
        end
      else  
        test.day_status = 2
        if self.usertype == 1
          if self.dpp_days[test.wday] == 0
            test.day_status = 0  
          end
        end
      end
  		test.save	
	  end
	end

  def start_date_proper
    if start_date?
      start_date.beginning_of_month.strftime('%d.%m.%Y')
    else
      @project = Project.find(self.projectid) 
      @project.start_date.strftime('%d.%m.%Y')
    end
  end

  def start_date_proper=(var)
    @project = Project.find(self.project_id)
    if Date.strptime(var,'%d.%m.%Y') < @project.start_date
      self.start_date=@project.start_date  
    else 
      self.start_date=Date.strptime(var,'%d.%m.%Y').beginning_of_month
    end
  end


  def end_date_proper
    if end_date?
      end_date.end_of_month.strftime('%d.%m.%Y')
    else 
      @project = Project.find(self.projectid) 
      @project.end_date.strftime('%d.%m.%Y')
    end
  end

  def end_date_proper=(var)
    @project = Project.find(self.project_id)
    if Date.strptime(var,'%d.%m.%Y') > @project.end_date
      self.end_date=@project.end_date  
    else 
      self.end_date=Date.strptime(var,'%d.%m.%Y').end_of_month
    end
  end
end
