class AddWorkTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :worktype, :integer, :default => 0
  end
end
