class AddWorkTripToJobdays < ActiveRecord::Migration
  def change
  	add_column :main_jobdays, :work_trip, :integer, :default => 0
  end
end
