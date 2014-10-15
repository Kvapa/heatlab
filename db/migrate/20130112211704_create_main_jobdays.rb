class CreateMainJobdays < ActiveRecord::Migration
  def change
    create_table :main_jobdays do |t|
      t.integer :main_job_id
      t.date :day
      t.integer :wday
      t.time :from
      t.time :until

      t.timestamps
    end
  end
end
