class AddWorkdaysColumnToJobmonth < ActiveRecord::Migration
  def change
    add_column :jobmonths, :workdays, :integer
  end
end
