class CreateEventgroupsUsers < ActiveRecord::Migration
  def change
    create_table :eventgroup_users do |t|
    	t.belongs_to :eventgroup
      	t.belongs_to :user
      	t.timestamps
    end
    add_index :eventgroup_users, :eventgroup_id
    add_index :eventgroup_users, :user_id
  end
end
