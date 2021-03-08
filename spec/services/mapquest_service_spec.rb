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
	end
end
