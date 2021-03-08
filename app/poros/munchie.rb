class Munchie
	attr_reader	:id, :destination_city, :travel_time, :forecast, :restaurant

	def initialize(city, distance, forecast, food)
		@id = nil
		@destination_city = city
		@travel_time = humanize(distance[:route][:formattedTime].split(':').map(&:to_i).inject(0) { |a, b| a * 60 + b })
		@forecast = {
									summary: forecast[:current][:weather][0][:description],
									temperature: forecast[:current][:temp].to_s
								}
		@restaurant = {
										name: food[:businesses][0][:name],
										address: food[:businesses][0][:location][:display_address].join
									}
	end

	def humanize(secs)
		[[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map{ |count, name|
			if secs > 0
				secs, n = secs.divmod(count)

				"#{n.to_i} #{name}" unless n.to_i==0
			end
		}.compact.reverse.join(' ')
	end

end