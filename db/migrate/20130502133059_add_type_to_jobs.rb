class AddTypeToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :contract, :integer, :default => 0
    add_column :jobs, :usertype, :integer, :default => 0 
  end
end
