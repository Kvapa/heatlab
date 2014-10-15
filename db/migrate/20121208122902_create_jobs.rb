class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :grant_id
      t.integer :user_id
      t.integer :position
      t.date :start_date
      t.date :end_date
      t.string :hours_per_week

      t.timestamps
    end
  end
end
