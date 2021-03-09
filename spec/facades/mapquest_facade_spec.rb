require 'rails_helper'

describe MapquestFacade, :vcr do
	describe "Class Methods" do
		describe '::get_travel_time' do
			it 'should return travel times' do
				travel_time = MapquestFacade.get_travel_time("Denver,co", "Boulder,co")

				expect(travel_time).to be_a(Hash)
				expect(travel_time.keys).to eq([:formatted_time, :unix_time])
				expect(travel_time[:formatted_time]).to be_a(String)
				expect(travel_time[:unix_time]).to be_a(Numeric)
			end

			it 'should return impossible if route is impossible' do
				travel_time = MapquestFacade.get_travel_time("Denver,co", "London,uk")

				expect(travel_time).to be_a(String)
				expect(travel_time).to eq("Impossible route")
			end
		end
	end
end