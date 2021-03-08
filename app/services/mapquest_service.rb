class MapquestService
	class << self

		def get_location_coordinates(location)
			response = conn.get('/geocoding/v1/address') do |req|
				req.params[:location] = location
				req.params[:key] = ENV['MAPQUEST_API_KEY']
			end
			parse(response)
		end

		def get_estimated_travel_time(start, destination)
			response = conn.get("/directions/v2/route") do |req|
				req.params[:key] = ENV['MAPQUEST_API_KEY']
				req.params[:from] = start
				req.params[:to] = destination
			end
			parse(response)
		end


		private

		def conn
			Faraday.new(url: 'http://www.mapquestapi.com')
		end

		def parse(response)
			JSON.parse(response.body, symbolize_names: true)
		end

	end
end