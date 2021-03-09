class ForecastFacade
	class << self
		def fetch_forecast(location)
			data = retrieve_weather(location)
			Forecast.new(current_weather(data), daily_weather(data), hourly_weather(data)) if data.present?
		end

		def retrieve_weather(location)
			data = MapquestService.get_location_coordinates(location)
			coords = data[:results][0][:locations][0][:latLng]
			raise ArgumentError if coords == { lat: 39.390897, lng: -99.066067 }
			ForecastService.weather_report(coords[:lat], coords[:lng])
		end

		def current_weather(data)
			CurrentWeather.new(data[:current])
		end

		def hourly_weather(data)
			data[:hourly].first(8).map do |hour|
				HourlyWeather.new(hour)
			end
		end

		def daily_weather(data)
			data[:daily].first(5).map do |day|
				DailyWeather.new(day)
			end
		end

		def weather_at_eta(destination, travel_time)
			weather = ForecastFacade.retrieve_weather(destination)
			weather[:hourly].find do |hour|
				hour[:dt] >= (Time.now + travel_time[:unix_time]).to_i
			end
		end

	end
end