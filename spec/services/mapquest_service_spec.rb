require 'rails_helper'

describe MapquestService, :vcr do
	describe "class methods" do
		it '::get_location_coordinates' do
			data = MapquestService.get_location_coordinates("Boulder,co")

			expect(data).to be_a Hash

			expect(data[:results][0][:locations][0]).to have_key :latLng
			expect(data[:results][0][:locations][0][:latLng]).to be_a(Hash)

			expect(data[:results][0][:locations][0][:latLng]).to have_key :lat
			expect(data[:results][0][:locations][0][:latLng][:lat]).to be_a(Numeric)

			expect(data[:results][0][:locations][0][:latLng]).to have_key :lng
			expect(data[:results][0][:locations][0][:latLng][:lng]).to be_a(Numeric)
		end

		it '::get_estimated_travel_time' do
			data = MapquestService.get_estimated_travel_time("Boulder,co", "Denver,co")

			expect(data).to be_a Hash

			expect(data.keys).to eq([:route, :info])
			expect(data[:route].size).to eq(23)
			expect(data[:route][:distance]).to be_a(Float)
			expect(data[:route][:formattedTime]).to be_a String
		end

	end
end
