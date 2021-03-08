class Background
	attr_reader :id, :image, :credit

	def initialize(data, location)
		@id = nil
		@image = {
			location: location,
			urls: data[:urls]
		}
		@credit = {
			author: data[:user][:user_name],
			profile_img: data[:user][:profile_image][:medium],
			links: data[:user][:links]
		}
	end
end