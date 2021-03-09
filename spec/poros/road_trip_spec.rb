require 'rails_helper'

describe RoadTrip do
	it 'exists and has attributes' do
		origin      = "Boulder,CO"
		destination = "Denver,CO"

		travel_time = { formatted_time: "00:34:01",
		                unix_time:      123123123 }

		weather     = { :dt         => 1615312800,
		                :temp       => 57.16,
		                :feels_like => 51.98,
		                :pressure   => 1008,
		                :humidity   => 32,
		                :dew_point  => 28.11,
		                :uvi        => 3.99,
		                :clouds     => 76,
		                :visibility => 10000,
		                :wind_speed => 1.79,
		                :wind_deg   => 298,
		                :weather    => [{ :id => 803, :main => "Clouds", :description => "broken clouds", :icon => "04d" }],
		                :pop        => 0 }

		road_trip = RoadTrip.new(origin, destination, travel_time, weather)

		expect(road_trip).to be_an_instance_of(RoadTrip)

		expect(road_trip.start_city).to eq(origin)
		expect(road_trip.end_city).to eq(destination)
		expect(road_trip.travel_time).to eq(travel_time[:formatted_time])
		expect(road_trip.weather_at_eta).to be_a(Hash)
		expect(road_trip.weather_at_eta.keys).to eq([:temperature, :conditions])
		expect(road_trip.weather_at_eta[:temperature]).to eq(weather[:temp])
		expect(road_trip.weather_at_eta[:conditions]).to eq(weather[:weather][0][:description])
	end

	it 'should return an empty hash for weather_at_eta if travel time is impossible' do
		origin      = "Boulder,CO"
		destination = "Denver,CO"
		travel_time = "Impossible route"
		weather     = nil

		road_trip = RoadTrip.new(origin, destination, travel_time, weather)

		expect(road_trip).to be_an_instance_of(RoadTrip)

		expect(road_trip.start_city).to eq(origin)
		expect(road_trip.end_city).to eq(destination)
		expect(road_trip.travel_time).to eq(travel_time)
		expect(road_trip.weather_at_eta).to be_empty
		expect(road_trip.weather_at_eta).to be_a(Hash)
	end

end