class AddJoinedColumnToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :joined, :boolean, :default => false
  end
end
