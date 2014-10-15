class AddXlsColumnToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :xls, :integer, :default => 1
  end
end
