class CreateJobdays < ActiveRecord::Migration
  def change
    create_table :jobdays do |t|
      t.integer :job_id
      t.date :day
      t.string :description
      t.integer :day_status

      t.timestamps
    end
  end
end
