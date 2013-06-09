require_relative 'food_truck'

class FoodTruckUpdater
  attr_accessor :name, :lat, :long

  def initialize(name, lat, long)
    @name = name
    @lat = lat
    @long = long
  end

  def update
    send_event( widget_name,
               { title: widget_title,
                 trucks: format_trucks(trucks_in_area)
                }
              )
  end


  private

  def format_truck(truck)
    {
      name: truck.name,
      accepts_cc: truck.accepts_cc,
      lat: truck.lat,
      long: truck.long,
      twitter_handle: truck.twitter_handle
    }
  end

  def format_trucks(trucks)
    formatted_trucks = []
    trucks.each do |truck|
      formatted_trucks << format_truck(truck)
    end

    formatted_trucks
  end

  def widget_name
    "food-trucks-#{name.downcase}"
  end

  def widget_title
    "#{name} Food Trucks"
  end

  def trucks_in_area
    trucks = []
    truck_data.each do |truck|
      new_truck = FoodTruck.new(truck)
      if truck_in_area?(new_truck)
        trucks << new_truck
      end
    end

    trucks
  end

  def truck_in_area?(truck)
    delta = 0.001
    (truck.long - long).abs < delta && (truck.lat - lat).abs < delta
  end

  def api_response
    http = Net::HTTP.new('foodtruckfiesta.com')
    response = http.request(Net::HTTP::Get.new('/apps/map_json.php'))
    response.body
  end

  def truck_data
    JSON.parse(api_response)['markers']
  end
end
