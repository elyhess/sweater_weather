class BackgroundsFacade
	class << self
		def fetch_background(location)
			image_data = BackgroundsService.random_image(location).first
			Background.new(image_data, location)
		end
	end
end