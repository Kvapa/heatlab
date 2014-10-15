class Eventgroup < ActiveRecord::Base
  attr_accessible :name, :project_id, :user_ids

  belongs_to :projects
  has_many :eventgroup_users
  has_many :users, through: :eventgroup_users
end
