require 'sinatra'
require 'bart'
require 'json'
require 'httparty'

get "/departures/:station1" do
  response['Access-Control-Allow-Origin'] = '*'
  departure_array = Bart(abbr: params[:station1].to_sym).departures
  response = {}
  departure_array.each_with_index do |departure, index|
    departure_hash = {}
    departure_hash[:destination_name] = departure.destination.name
    departure_hash[:estimates] = []
    departure.estimates.each do |estimate|
      estimate_hash = {}
      estimate_hash[:direction] = estimate.direction
      estimate_hash[:length] = estimate.length
      estimate_hash[:minutes] = estimate.minutes
      estimate_hash[:platform] = estimate.platform
      departure_hash[:estimates] << estimate_hash
    end
    response[index] = departure_hash
  end
  response.to_json
end

get "/routes" do
  response['Access-Control-Allow-Origin'] = '*'
  url = "http://api.bart.gov/api/sched.aspx?cmd=depart&" +
        "orig=#{params[:station1]}&dest=#{params[:station2]}&" +
        "date=now&key=MW9S-E7SL-26DU-VV8V"
  response = HTTParty.get(url)
  begin
    response["root"]["schedule"]["request"]["trip"][0].to_json
  rescue
    "error"
  end
end
