class MapquestFacade
	class << self

		def get_travel_time(origin, destination)
			eta = MapquestService.get_estimated_travel_time(origin, destination)
			if eta[:info][:statuscode] == 402
				"Impossible route"
			else
				{
					formatted_time: eta[:route][:formattedTime],
					unix_time: eta[:route][:realTime]
				}
			end
		end

	end
end