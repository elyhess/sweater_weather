require 'rails_helper'

describe Munchie, :vcr do
	it 'exists and has attributes' do
		munchie = MunchieFacade.create_food_itinerary("Boulder,co", "Denver,co", "Burger")

		expect(munchie).to be_an_instance_of(Munchie)
		expect(munchie.destination_city).to be_a(String)
		expect(munchie.destination_city).to eq("Denver,co")
		expect(munchie.forecast).to be_a(Hash)
		expect(munchie.forecast.keys).to eq([:summary, :temperature])
		expect(munchie.forecast[:summary]).to eq("overcast clouds")
		expect(munchie.forecast[:temperature]).to eq("51.17")
		expect(munchie.id).to be_nil
		expect(munchie.restaurant).to be_a(Hash)
		expect(munchie.restaurant.keys).to eq([:name, :address])
		expect(munchie.restaurant[:name]).to eq("Crown Burgers")
		expect(munchie.restaurant[:address]).to eq("2192 S Colorado BlvdDenver, CO 80222")
		expect(munchie.travel_time).to be_a(String)
		expect(munchie.travel_time).to eq("00:34:01")
	end
end