#!/usr/bin/env ruby
require 'net/http'
require 'csv'

# Track the Stock Value of a company by it’s stock quote shortcut using the 
# official yahoo stock quote api
# 
# This will record all current values and changes to all stock indizes you
# indicate in the `yahoo_stockquote_symbols` array. Each value is then available
# in the `yahoo_stock_quote_[symbol_slug]` variables and combined in a list
# `yahoo_stock_quote_list` which contains them all.

# Config
# ------
# Symbols of all indizes you want to track
stockquote_symbols = [
  'CVT'      # will become `yahoo_stock_quote_cvt`
]

SCHEDULER.every '5m', :first_in => 0 do |job|
  stockquote_symbols.each do |symbol|
=begin
    http = Net::HTTP.new("dev.markitondemand.com")
    response = http.request(Net::HTTP::Get.new("/Api/v2/Quote/json?symbol=#{symbol}"))

    if response.code != "200"
      puts "Quote communication error (status-code: #{response.code})\n#{response.body}"
    else
      data = JSON.parse(response.body)

      symbol = data['Symbol']
      current = data['LastPrice'].to_f
      change = data['Change'].to_f

      widgetVarname = "stock_quote_" + symbol.gsub(/[^A-Za-z0-9]+/, '_').downcase
      widgetData = {
        current: current
      }

      if change != 0.0
        widgetData[:last] = current - change
      end

      if defined?(send_event)
        send_event(widgetVarname, widgetData)
      end
    end
=end
  end
end
