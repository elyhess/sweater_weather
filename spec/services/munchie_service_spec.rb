require 'rails_helper'

describe MunchieService, :vcr do
	describe "class methods" do
		it '::get_food_data' do
			data = MunchieService.get_food_data("Burger","Denver,co")

			expect(data).to be_a Hash
			expect(data.keys).to eq([:businesses, :total, :region])
			expect(data[:businesses].size).to eq(1)
			expect(data[:businesses][0]).to have_key(:name)
			expect(data[:businesses][0][:name]).to be_a(String)
			expect(data[:businesses][0]).to have_key(:location)
			expect(data[:businesses][0][:location]).to be_a(Hash)
			expect(data[:businesses][0][:location]).to have_key(:display_address)
			expect(data[:businesses][0][:location][:display_address]).to be_an(Array)
			expect(data[:businesses][0][:location][:display_address][0]).to be_an(String)
		end
	end
end
