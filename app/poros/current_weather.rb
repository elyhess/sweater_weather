class CurrentWeather
	attr_reader :datetime,
	            :sunrise,
	            :sunset,
	            :temperature,
	            :feels_like,
	            :humidity,
	            :uvi,
	            :visibility,
	            :conditions,
	            :icon

	def initialize(data)
		@datetime    = Time.at(data[:dt]).getlocal.to_s
		@sunrise     = Time.at(data[:sunrise]).getlocal.to_s
		@sunset      = Time.at(data[:sunset]).getlocal.to_s
		@temperature = data[:temp]
		@feels_like  = data[:feels_like]
		@humidity    = data[:humidity]
		@uvi         = data[:uvi]
		@visibility  = data[:visibility]
		@conditions  = data[:weather][0][:description]
		@icon        = data[:weather][0][:icon]
	end
end