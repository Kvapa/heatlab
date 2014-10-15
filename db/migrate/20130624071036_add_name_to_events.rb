class AddNameToEvents < ActiveRecord::Migration
  def change
    add_column :events, :name, :string
    add_column :events, :date_until, :date 
  end
end
