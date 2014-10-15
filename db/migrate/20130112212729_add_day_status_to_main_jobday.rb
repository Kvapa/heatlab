class AddDayStatusToMainJobday < ActiveRecord::Migration
  def change
    add_column :main_jobdays, :day_status, :integer
  end
end
