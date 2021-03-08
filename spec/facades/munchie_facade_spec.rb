require 'rails_helper'

describe MunchieFacade, :vcr do
	describe "Class Methods" do
		it '::create_food_itinerary' do
			munchie = MunchieFacade.create_food_itinerary("Denver,co", "Boulder,co", "Burger")

			expect(munchie).to be_an_instance_of(Munchie)
		end
	end
end