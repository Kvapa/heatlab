class CreateProjectActivities < ActiveRecord::Migration
  def change
    create_table :project_activities do |t|
      t.integer :project_position_id
      t.string :description
      t.integer :position

      t.timestamps
    end
  end
end
