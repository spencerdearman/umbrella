# ./weather.rb

require "http"
require "json"

# Importing secret keys
google_api_key = ENV.fetch("GMAPS_KEY")
pirate_api_key = ENV.fetch("PIRATE_WEATHER_KEY")

# Prompting the user and giving introduction
width = 40
puts ("-" * width)
puts "Will it rain?".center(width)
puts ("-" * width)
puts
puts("Please enter your location:")
user_location = gets.chomp
puts("Determining forecast for #{user_location.capitalize}...")

# Sending HTTP request and retrieving JSON
google_url = "https://maps.googleapis.com/maps/api/geocode/json?address=
            #{user_location}&key=#{google_api_key}"
raw_google_data = HTTP.get(google_url)
google_json = JSON.parse(raw_google_data)

# Pulling latitude and longitude from JSON
location = google_json["results"][0]["geometry"]["location"]
latitude = location["lat"]
longitude = location["lng"]

# Beginning of actual weather forecast output
puts
puts ("-" * width)
puts "#{user_location.capitalize} Weather Forecast".center(width)
puts ("-" * width)


# Plugging in the latitude and longitude into pirate weather
pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_api_key}/#{latitude},#{longitude}"
raw_pirate_data = HTTP.get(pirate_weather_url)
pirate_json = JSON.parse(raw_pirate_data)

current_weather = pirate_json["currently"]
minutely_weather = pirate_json["minutely"]
current_temp = current_weather["temperature"]
minutely_forecast = minutely_weather["summary"]

# Printing out actual output
puts "Your coordinates are #{latitude}, #{longitude}."
puts "Current Temperature: #{current_temp}°F"
if minutely_forecast
  puts "Next hour: #{minutely_forecast}"
end
puts ("-" * width)
