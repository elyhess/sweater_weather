class RoadTrip
	attr_reader :id,
	            :start_city,
	            :end_city,
	            :travel_time,
	            :weather_at_eta

	def initialize(origin, destination, travel_time, weather)
		@id             = nil
		@start_city     = origin
		@end_city       = destination
		@travel_time    = travel_time
		@weather_at_eta = weather_at_location(weather)
	end

	def weather_at_location(weather)
		if @travel_time == "Impossible route"
			{}
		else
			@travel_time = @travel_time[:formatted_time]
			{
				temperature: weather[:temp],
				conditions:  weather[:weather][0][:description]
			}
		end
	end

end