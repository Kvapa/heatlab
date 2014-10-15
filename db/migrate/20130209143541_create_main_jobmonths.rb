class CreateMainJobmonths < ActiveRecord::Migration
  def change
    create_table :main_jobmonths do |t|
      t.integer :main_job_id
      t.date :month
      t.integer :workload
      t.string :workdays

      t.timestamps
    end
  end
end
