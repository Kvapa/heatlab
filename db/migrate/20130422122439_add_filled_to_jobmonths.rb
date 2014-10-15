class AddFilledToJobmonths < ActiveRecord::Migration
  def change
    add_column :jobmonths, :filled, :boolean, :default => false
    add_column :jobmonths, :checked, :boolean, :default => false
  end
end
