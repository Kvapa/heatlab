class CreateProjectPositions < ActiveRecord::Migration
  def change
    create_table :project_positions do |t|
      t.integer :project_id
      t.string :name

      t.timestamps
    end
  end
end
