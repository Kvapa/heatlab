class MainJobday < ActiveRecord::Base
  attr_accessible :day, :from, :main_job_id, :until, :day_status,:work_trip, :trip_town

  before_update :test

  def test
  	if self.day_status == 0 || self.day_status == 3 || self.day_status == 4
  		 self.from=self.day.beginning_of_day
       self.until=self.day.beginning_of_day		
  	end
  	if (self.until-self.from) >0
  		self.hours=(self.until-self.from)/3600
  	else
  		self.hours=0
  	end	
    if self.day_status !=5
      self.work_trip =0
    end
  end 
end
