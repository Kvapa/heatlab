class MainJob < ActiveRecord::Base
  attr_accessible :main_worklist_id, :user_id
  validates :user_id, :numericality => { :only_integer => true }
  after_create :create_main_workdays
  belongs_to :user
  belongs_to :main_worklist
  has_many :main_jobdays, :dependent => :delete_all 
  has_many :main_jobmonths, :dependent => :delete_all 

  def create_main_workdays	
  	@main_worklist = MainWorklist.find(self.main_worklist_id)
  	(@main_worklist.year.beginning_of_year..@main_worklist.year.end_of_year).each do |day|
      if day == day.beginning_of_month
        test=MainJobmonth.new
        test.main_job_id = self.id
        test.month=day
        test.save
      end
  		test=MainJobday.new
  		test.main_job_id = self.id
  		test.day=day
      test.wday=day.wday
      test.from=day.beginning_of_day   
      test.until=day.beginning_of_day  
      test.hours=0
      if day.wday == 0 || day.wday == 6
        test.day_status = 0
      elsif day.holiday?(:cz)
        test.day_status = 1
      else
        test.day_status = 2
      end
  		test.save	
	  end
	end
end
