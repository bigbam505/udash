require 'net/http'
require 'json'
require 'nokogiri'
class FoodSpecialParser
  def parse
    parse_specials_list(document.css('ul.fl_food_menu_items')[1])
  end

  private

  def parse_special(list_item)
    title = list_item.css('span.fl_food_menu_item_name')[0].content
    description = list_item.css('span.fl_food_menu_item_description')[0].content
    price = list_item.css('span.fl_food_menu_item_price')[0].content
    FoodSpecial.new(title, description, price )
  end

  def parse_specials_list(list)
    specials = []
    list.css('li').each do |list_item|
      if(list_item.css('h8').count == 0)
        specials << parse_special(list_item)
      end
    end

    specials
  end

  def document
    Nokogiri::HTML(response_body)
  end

  def response_body
    if(@response_body)
      return @response_body
    end
    http = Net::HTTP.new('www.blvdcafecatering.com')
    @response_body = http.request(Net::HTTP::Get.new('/category/dailyspecials')).body
  end
end

class FoodSpecial
  attr_accessor :title, :description, :price

  def initialize(title, description, price)
    @title = title
    @description = description
    @price = price
  end
end

class FoodSpecialUpdater

  def update
    specials = FoodSpecialParser.new.parse
    send_event(widget_name, { title: widget_title, specials: format_specials(specials) })
  end

  private

  def format_special(special)
    {
      title: special.title,
      description: special.description,
      price: special.price
    }
  end

  def format_specials(specials)
    formatted_specials = []
    specials.each do |special|
      formatted_specials << format_special(special)
    end

    formatted_specials
  end

  def widget_title
    'Boulevard Cafe Specials'
  end

  def widget_name
    'blvd-food-specials'
  end
end

SCHEDULER.every '1m', :first_in => 0 do |job|
  FoodSpecialUpdater.new.update
end

