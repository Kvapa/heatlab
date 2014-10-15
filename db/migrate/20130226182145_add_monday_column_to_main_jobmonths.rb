class AddMondayColumnToMainJobmonths < ActiveRecord::Migration
  def change
    add_column :main_jobmonths, :monday, :boolean
    add_column :main_jobmonths, :tuesday, :boolean
    add_column :main_jobmonths, :wednesday, :boolean
    add_column :main_jobmonths, :thursday, :boolean
    add_column :main_jobmonths, :friday, :boolean
  end
end
