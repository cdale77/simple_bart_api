require 'sinatra'
require 'bart'
require 'json'
#require 'pry'

get "/departures/:station_name" do
  "you wanted station #{params[:station_name]}"
  departure_array = Bart(abbr: params[:station_name].to_sym).departures
  response = {}
  departure_array.each_with_index do |departure, index|
    departure_hash = {}
    departure_hash[:destination_name] = departure.destination.name
    departure.estimates.each do |estimate|
      estimate_hash = {}
      estimate_hash[:direction] = estimate.direction
      estimate_hash[:length] = estimate.length
      estimate_hash[:minutes] = estimate.minutes
      estimate_hash[:platform] = estimate.platform
      departure_hash[:estimates] = estimate_hash
    end
    #response.merge!(departure_hash)
    response[index] = departure_hash
  end
  response.to_json
end


