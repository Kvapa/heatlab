class CreateMainWorklists < ActiveRecord::Migration
  def change
    create_table :main_worklists do |t|
      t.string :name
      t.date :year

      t.timestamps
    end
  end
end
