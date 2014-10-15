class Jobmonth < ActiveRecord::Base
  attr_accessible :job_id, :month, :workload, :filled, :checked
end
