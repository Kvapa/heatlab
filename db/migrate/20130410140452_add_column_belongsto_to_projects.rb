class AddColumnBelongstoToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :belongsto, :integer, :default => 0
  end
end
