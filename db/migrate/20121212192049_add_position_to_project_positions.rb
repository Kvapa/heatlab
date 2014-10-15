class AddPositionToProjectPositions < ActiveRecord::Migration
  def change
    add_column :project_positions, :position, :integer
  end
end
