require 'net/http'
require 'xmlsimple'
require_relative '../lib/weather_updater'

# Get a WOEID (Where On Earth ID)
# for your location from here:
# http://woeid.rosselliot.co.nz/

# {city_name: 'Boston', woe_id: 12345}
cities = []
cities << {city: 'McLean', woe_id: 2448240}
cities << {city: 'Arlington', woe_id: 12766856}
cities << {city: 'Gurgaon', woe_id: 2295020}

SCHEDULER.every '15m', :first_in => 0 do |job|
  cities.each do |city|
    WeatherUpdater.new(city[:city], city[:woe_id]).update
  end
end
