class ImageFacade
	class << self
		def fetch_background(location)
			image_data = ImageService.random_image(location).first
			Image.new(image_data, location)
		end
	end
end