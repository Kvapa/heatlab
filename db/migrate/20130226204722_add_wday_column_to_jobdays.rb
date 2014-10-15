class AddWdayColumnToJobdays < ActiveRecord::Migration
  def change
    add_column :jobdays, :wday, :integer
  end
end
