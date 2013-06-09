class FoodTruck
  attr_accessor :name, :lat, :long, :twitter_handle, :accepts_cc

  def initialize(raw_data)
    @name = raw_data['print_name']
    @lat = raw_data['coord_lat'].to_f
    @long = raw_data['coord_long'].to_f
    @twitter_handle = raw_data['truck']
    @accepts_cc = raw_data['alerttext'].include?('Credit Cards Accepted:<\b> Yes')
  end
end
