class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
    	t.integer :project_id
      	t.date :day
      	t.string :description

    	t.timestamps
    end
  end
end
