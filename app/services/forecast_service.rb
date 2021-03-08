class ForecastService
	class << self

		def weather_report(lat, lon)
			response = conn.get('/data/2.5/onecall') do |req|
				req.params[:appid] = ENV['WEATHER_API_KEY']
				req.params[:lat] = lat
				req.params[:lon] = lon
				req.params[:exclude] = "minutely,alerts"
				req.params[:units] = "imperial"
			end
			parse(response)
		end

		private

		def conn
			Faraday.new(url: "http://api.openweathermap.org")
		end

		def parse(response)
			JSON.parse(response.body, symbolize_names: true)
		end

	end
end