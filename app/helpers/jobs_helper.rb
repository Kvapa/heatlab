#encoding: utf-8
module JobsHelper
	def name_medium(var)
		user = User.find(var)
		user.surname + " " + user.name
	end

	def position_selected(var)
		position = GrantPosition.find(var)
		position.name
	end

	

	def jobs_rest_workload(job_id,year,month)
		job = Job.find(job_id)
		projects = User.find(job.user_id).projects

		if job.usertype == 0
			main_worklist = MainWorklist.where("year=?",Date.new(year,1).beginning_of_year)[0]
			main_job = MainJob.where("main_worklist_id=? and user_id=?",main_worklist.id,job.user_id)[0]

			if main_job.blank?
				heatlab_workload = 0		
			else
				if MainJobmonth.where("main_job_id=? and month=?",main_job.id,Date.new(year,month).beginning_of_month)[0].workload
					heatlab_workload = MainJobmonth.where("main_job_id=? and month=?",main_job.id,Date.new(year,month).beginning_of_month)[0].workload
				else
					heatlab_workload = 0
				end
			end
		end

		projects_workload = 0
		projects.each do |p|
			Job.where("user_id=? and project_id=?",job.user_id,p.id).each do |j|
				if Jobmonth.where("job_id=? and month=?",j.id, Date.new(year,month).beginning_of_month)[0]
					if Jobmonth.where("job_id=? and month=?",j.id, Date.new(year,month).beginning_of_month)[0].workload
						projects_workload += Jobmonth.where("job_id=? and month=?",j.id, Date.new(year,month).beginning_of_month)[0].workload
					end
				end
			end
		end
		if job.usertype == 0
	  		[heatlab_workload, projects_workload]
	  	else
	  		projects_workload	
	  	end
	end
	
end
