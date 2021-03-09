class ImageFacade
	class << self
		def create_image(location)
			image_data = ImageService.search_image(location)
			Image.new(image_data[:results][0], location)
		end
	end
end