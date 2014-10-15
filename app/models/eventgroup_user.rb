class EventgroupUser < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :eventgroup
  belongs_to :user
end