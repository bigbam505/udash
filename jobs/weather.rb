require 'net/http'
require 'xmlsimple'
require_relative '../lib/weather_updater'

# Get a WOEID (Where On Earth ID)
# for your location from here:
# http://woe_id.rosselliot.co.nz/

# {city_name: 'Boston', woe_id: 12345}
cities = []
cities << {city: 'McLean', woe_id: 2448240}

SCHEDULER.every '15m', :first_in => 0 do |job|
  cities.each do |city|
    WeatherUpdater.new(city[:city], city[:woe_id]).update
  end
end
