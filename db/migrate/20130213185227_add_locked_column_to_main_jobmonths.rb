class AddLockedColumnToMainJobmonths < ActiveRecord::Migration
  def change
    add_column :main_jobmonths, :locked, :boolean, :default => false
  end
end
