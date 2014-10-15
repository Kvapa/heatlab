class CreateMainJobs < ActiveRecord::Migration
  def change
    create_table :main_jobs do |t|
      t.string :user_id
      t.integer :main_worklist_id

      t.timestamps
    end
  end
end
