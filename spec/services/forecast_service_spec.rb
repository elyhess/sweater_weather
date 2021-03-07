require 'rails_helper'

describe ForecastService, :vcr do
	describe "class methods" do
		it '::weather_report' do
			data = ForecastService.weather_report(40.015831, -105.27927)

			expect(data).to be_a Hash

			expect(data).to_not have_key(:minutely)
			expect(data).to_not have_key(:alerts)

			expect(data[:current]).to have_key(:dt)
			expect(data[:current][:dt]).to be_a Numeric
			expect(data[:current]).to have_key :sunrise
			expect(data[:current][:sunrise]).to be_a Numeric
			expect(data[:current]).to have_key :sunset
			expect(data[:current][:sunset]).to be_a Numeric
			expect(data[:current]).to have_key :temp
			expect(data[:current][:temp]).to be_a Numeric
			expect(data[:current]).to have_key :weather
			expect(data[:current][:weather]).to be_a Array
			expect(data[:current][:weather][0]).to be_a Hash
			expect(data[:current][:weather][0]).to have_key :description
			expect(data[:current][:weather][0][:description]).to be_a String
			expect(data[:current][:weather][0]).to have_key :icon
			expect(data[:current][:weather][0][:icon]).to be_a String

			expect(data[:hourly][0][:dt]).to be_a Numeric
			expect(data[:hourly][0][:temp]).to be_a Numeric
			expect(data[:hourly][0][:weather]).to be_an Array
			expect(data[:hourly][0][:weather][0][:id]).to be_an Integer
			expect(data[:hourly][0][:weather][0][:main]).to be_a String
			expect(data[:hourly][0][:weather][0][:description]).to be_a String
			expect(data[:hourly][0][:weather][0][:icon]).to be_a String

			expect(data[:daily][0]).to have_key :sunrise
			expect(data[:daily][0][:sunrise]).to be_a Numeric
			expect(data[:daily][0]).to have_key :sunset
			expect(data[:daily][0][:sunset]).to be_a Numeric
			expect(data[:daily][0]).to have_key :temp
			expect(data[:daily][0][:temp]).to be_a Hash
			expect(data[:daily][0]).to have_key :weather
			expect(data[:daily][0][:weather]).to be_a Array
			expect(data[:daily][0]).to have_key(:dt)
			expect(data[:daily][0][:dt]).to be_a Numeric
			expect(data[:daily][0][:temp]).to have_key(:min)
			expect(data[:daily][0][:temp][:min]).to be_a Numeric
			expect(data[:daily][0][:temp]).to have_key(:max)
			expect(data[:daily][0][:temp][:max]).to be_a Numeric

			expect(data[:daily][0][:weather]).to be_an Array
			expect(data[:daily][0][:weather][0]).to be_a Hash
			expect(data[:daily][0][:weather][0]).to have_key(:id)
			expect(data[:daily][0][:weather][0][:id]).to be_an Integer
			expect(data[:daily][0][:weather][0]).to have_key(:main)
			expect(data[:daily][0][:weather][0][:main]).to be_a String
			expect(data[:daily][0][:weather][0]).to have_key(:description)
			expect(data[:daily][0][:weather][0][:description]).to be_a String
			expect(data[:daily][0][:weather][0]).to have_key(:icon)
			expect(data[:daily][0][:weather][0][:icon]).to be_a String
		end
	end
end
