class AddDepartureTimeToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :departure_time, :datetime
  end
end
