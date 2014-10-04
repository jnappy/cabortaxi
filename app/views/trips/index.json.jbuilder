json.array!(@trips) do |trip|
  json.extract! trip, :id, :origin, :destination, :latitude, :longitude, :number_of_people
  json.url trip_url(trip, format: :json)
end
