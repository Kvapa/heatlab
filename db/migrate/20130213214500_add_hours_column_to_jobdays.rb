class AddHoursColumnToJobdays < ActiveRecord::Migration
  def change
    add_column :jobdays, :hours, :float, :default => 0
  end
end
