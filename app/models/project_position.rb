class ProjectPosition < ActiveRecord::Base
	acts_as_list
  attr_accessible :name, :project_id, :position_number
  belongs_to :project
  has_many :project_activities, :dependent => :destroy
end
