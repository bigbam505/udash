require 'net/http'
require 'json'
require_relative '../lib/food_truck_updater'

locations = []
locations << {location: 'Greensboro', lat: 38.9236427, long: -77.2306207 }

SCHEDULER.every '5m', :first_in => 0 do |job|
  locations.each do |location|
    FoodTruckUpdater.new(location[:location],
                         location[:lat],
                         location[:long]).update
  end
end
