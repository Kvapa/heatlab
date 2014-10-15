class MainWorklist < ActiveRecord::Base
  attr_accessible :name, :year

  
  validates :name, :presence => true

  has_many :main_jobs,:dependent => :destroy
  has_many :users, :through => :main_jobs


  before_create :create_worklist

  def create_worklist
  	self.year=self.year.beginning_of_year
  end
end
