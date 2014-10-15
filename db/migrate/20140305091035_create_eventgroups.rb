class CreateEventgroups < ActiveRecord::Migration
  def change
    create_table :eventgroups do |t|
    	t.string :name
    	t.integer :project_id
     	t.string :description

    	t.timestamps
    end
  end
end
