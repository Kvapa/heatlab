module MainJobsHelper

	def main_jobs_rest_workload(user_id,year,month)
		projects = User.find(user_id).projects

		projects_workload = 0
		projects.each do |p|
			Job.where("user_id=? and project_id=?",user_id,p.id).each do |j|
				if Jobmonth.where("job_id=? and month=?",j.id, Date.new(year,month).beginning_of_month)[0]
					projects_workload += Jobmonth.where("job_id=? and month=?",j.id, Date.new(year,month).beginning_of_month)[0].workload
				end
			end
		end
		projects_workload
	end
end
