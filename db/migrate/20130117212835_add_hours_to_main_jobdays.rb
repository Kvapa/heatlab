class AddHoursToMainJobdays < ActiveRecord::Migration
  def change
    add_column :main_jobdays, :hours, :float
  end
end
