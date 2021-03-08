class MunchieFacade
	class << self
		def create_food_itinerary(start, destination, food)
			trip_distance = MapquestService.get_estimated_travel_time(start, destination)
			lat = trip_distance[:route][:boundingBox][:lr][:lat]
			lon = trip_distance[:route][:boundingBox][:lr][:lng]
			forecast_data = ForecastFacade.food_forecast(lat, lon)
			munchie_data = MunchieService.get_food_data(food, destination)
			Munchie.new(destination, trip_distance, forecast_data, munchie_data)
		end
	end
end