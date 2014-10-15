class Event < ActiveRecord::Base
  attr_accessible :project_id, :description,:day_proper, :user_ids, :name, :date_until_proper, :eventgroup

  attr_accessor :eventgroup

  belongs_to :projects
  has_many :event_users
  has_many :users, through: :event_users


  def day_proper
  	if day?
  		day.strftime('%d.%m.%Y')
  	else 
  		Time.now.strftime('%d.%m.%Y')
  	end
  end

  def day_proper=(var)
  	self.day=Date.strptime(var,'%d.%m.%Y')
  end

  def date_until_proper
    if date_until?
      date_until.strftime('%d.%m.%Y')
    else 
      Time.now.strftime('%d.%m.%Y')
    end
  end

  def date_until_proper=(var)
    self.date_until=Date.strptime(var,'%d.%m.%Y')
  end
end
