class AddRetireToUsers < ActiveRecord::Migration
  def change
    add_column :users, :retire, :date
    add_column :users, :contract, :integer
    add_column :users, :contract_end, :date
  end
end
