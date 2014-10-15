class WorkNameToProjects < ActiveRecord::Migration
	def change
  	add_column :projects, :workname, :string
  end
end
