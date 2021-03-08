class MunchieSerializer
	include FastJsonapi::ObjectSerializer
	attributes :destination_city, :travel_time, :forecast, :restaurant
end
