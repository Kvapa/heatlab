class ProjectActivity < ActiveRecord::Base
  attr_accessible :description, :position, :project_position_id
  belongs_to :project_position
end
