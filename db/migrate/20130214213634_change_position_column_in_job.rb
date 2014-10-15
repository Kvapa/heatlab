class ChangePositionColumnInJob < ActiveRecord::Migration
  def change
  	change_column :jobs, :position, :integer
  end

  
end
