class AddMondayColumnToJobmonths < ActiveRecord::Migration
  def change
    add_column :jobmonths, :monday, :boolean
    add_column :jobmonths, :tuesday, :boolean
    add_column :jobmonths, :wednesday, :boolean
    add_column :jobmonths, :thursday, :boolean
    add_column :jobmonths, :friday, :boolean
  end
end
