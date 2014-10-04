class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :origin
      t.string :destination
      t.float :latitude
      t.float :longitude
      t.integer :number_of_people

      t.timestamps
    end
  end
end
