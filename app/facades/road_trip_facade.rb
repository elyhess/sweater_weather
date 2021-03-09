class RoadTripFacade
	class << self

		def create_road_trip(origin, destination)
			travel_time = MapquestFacade.get_travel_time(origin, destination)
			weather_at_eta = ForecastFacade.weather_at_eta(destination, travel_time) unless travel_time == "Impossible route"
			RoadTrip.new(origin, destination, travel_time, weather_at_eta)
		end

	end
end