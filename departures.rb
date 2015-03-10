require 'sinatra'

get "/departures/:station_name" do
  "you wanted station #{params[:station_name]}"
end


