class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :email
      t.string :firstname
      t.string :surname
      t.string :fullname

      t.timestamps
    end
  end
end
