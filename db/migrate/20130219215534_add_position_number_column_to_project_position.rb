class AddPositionNumberColumnToProjectPosition < ActiveRecord::Migration
  def change
    add_column :project_positions, :position_number, :string
  end
end
