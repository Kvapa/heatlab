class AddDecreeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :decree50, :date
  end
end
