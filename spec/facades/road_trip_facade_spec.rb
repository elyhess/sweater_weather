require 'rails_helper'

describe RoadTripFacade, :vcr do
	describe "Class Methods" do
		it '::create_road_trip' do
			road_trip = RoadTripFacade.create_road_trip("Denver,co", "Boulder,co")

			expect(road_trip).to be_an_instance_of(RoadTrip)
		end
	end
end