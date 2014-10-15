class AddTripTownColumnToMainJobdays < ActiveRecord::Migration
  def change
    add_column :main_jobdays, :trip_town, :string
  end
end
