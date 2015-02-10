class User < ActiveRecord::Base
	has_secure_password
	validates_presence_of :password, :on => :create
	validates_uniqueness_of :login

	validates :login, :length => { :minimum => 5, :maximum => 50 }

  attr_accessible :email, :firstname, :fullname, :login, :surname, :password, :password_confirmation, :personal_number, :worktype, :admin, :decree50_proper, :contract, :contract_end_proper, :retire_proper, :birthday_proper, :active

  has_many :jobs
  has_many :projects, :through => :jobs

  has_many :main_jobs
  has_many :main_worklists, :through => :main_jobs

  has_many :job_checks

  has_many :event_users
  has_many :events, through: :event_users

  def sur_firstname
    "#{self.surname} #{self.firstname}"
  end

  def decree50_proper
    if decree50?
      decree50.strftime('%d.%m.%Y')
    end
  end

  def decree50_proper=(var)
    if !var.blank?
      self.decree50=Date.strptime(var,'%d.%m.%Y')
    end
  end

  def contract_end_proper
    if contract_end?
      contract_end.strftime('%d.%m.%Y')
    end
  end

  def contract_end_proper=(var)
    if !var.blank?
      self.contract_end=Date.strptime(var,'%d.%m.%Y')
    end
  end

  def retire_proper
    if retire?
      retire.strftime('%d.%m.%Y')
    end
  end

  def retire_proper=(var)
    if !var.blank?
      self.retire=Date.strptime(var,'%d.%m.%Y')
    end
  end

  def birthday_proper
    if birthday?
      birthday.strftime('%d.%m.%Y')
    end
  end

  def birthday_proper=(var)
    if !var.blank?
      self.birthday=Date.strptime(var,'%d.%m.%Y')
    end
  end
end
