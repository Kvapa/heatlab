class ChangeIdInJobs < ActiveRecord::Migration
 def change
  	rename_column :jobs, :grant_id, :project_id
  end
end
