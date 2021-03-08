class MunchieService
	class << self
		def get_food_data(food_type, location)
			response = conn.get('/v3/businesses/search') do |req|
				req.headers["Authorization"] = ENV['YELP_API_KEY']
				req.params['term'] = food_type
				req.params['location'] = location
				req.params['limit'] = 1
				req.params['open_now'] = true
			end
			parse_data(response)
		end

		private

		def conn
			Faraday.new(url: 'https://api.yelp.com')
		end

		def parse_data(response)
			JSON.parse(response.body, symbolize_names: true)
		end

	end
end