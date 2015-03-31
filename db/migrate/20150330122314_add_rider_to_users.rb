class AddRiderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rider, :date
  end
end
