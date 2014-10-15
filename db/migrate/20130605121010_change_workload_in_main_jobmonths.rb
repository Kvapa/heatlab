class ChangeWorkloadInMainJobmonths < ActiveRecord::Migration
  def change
  	change_column :main_jobmonths, :workload, :float
  end
end
