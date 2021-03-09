class ImageService
	class << self

		def search_image(location)
			response = conn.get('/search/photos') do |req|
				req.params[:client_id] = ENV['UNSPLASH_API_KEY']
				req.params[:query] = location
				req.params[:page] = 1
				req.params[:per_page] = 1
				req.params[:content_filter] = "high"
			end
			parse(response)
		end

		private

		def conn
			Faraday.new(url: "https://api.unsplash.com")
		end

		def parse(response)
			JSON.parse(response.body, symbolize_names: true)
		end

	end
end