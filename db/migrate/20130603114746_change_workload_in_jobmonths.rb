class ChangeWorkloadInJobmonths < ActiveRecord::Migration
  def change
  	change_column :jobmonths, :workload, :float
  end
end
