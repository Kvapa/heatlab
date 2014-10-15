class CreateJobmonths < ActiveRecord::Migration
  def change
    create_table :jobmonths do |t|
      t.integer :job_id
      t.date :month
      t.integer :workload

      t.timestamps
    end
  end
end
