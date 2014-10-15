class Project < ActiveRecord::Base
  attr_accessible :end_date,:workname, :name, :number, :start_date, :start_date_proper, :end_date_proper, :xls, :belongsto

  has_many :jobs,:dependent => :destroy
  has_many :users, :through => :jobs
  has_many :project_positions, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :eventgroups, :dependent => :destroy

  def start_date_proper
  	if start_date?
  		start_date.strftime('%d.%m.%Y')
  	else 
  		Time.now.strftime('%d.%m.%Y')
  	end
  end

  def start_date_proper=(var)
  	self.start_date=Date.strptime(var,'%d.%m.%Y')
  end


  def end_date_proper
    if end_date?
  		end_date.strftime('%d.%m.%Y')
  	else 
  		Time.now.strftime('%d.%m.%Y')
  	end
  end

  def end_date_proper=(var)
    self.end_date=Date.strptime(var,'%d.%m.%Y')
  end
end
