class Munchie
	attr_reader	:id, :destination_city, :travel_time, :forecast, :restaurant

	def initialize(city, distance, forecast, food)
		@id = nil
		@destination_city = city
		@travel_time = distance[:route][:formattedTime]
		@forecast = {
									summary: forecast[:current][:weather][0][:description],
									temperature: forecast[:current][:temp].to_s
								}
		@restaurant = {
										name: food[:businesses][0][:name],
										address: food[:businesses][0][:location][:display_address].join
									}
	end
end