require 'rails_helper'

describe HourlyWeather, :vcr do
	it 'exists and has attributes' do
		data = ForecastService.weather_report(40.015831, -105.27927)[:hourly].first

		weather = HourlyWeather.new(data)

		expect(weather.conditions).to eq(data[:weather][0][:description])
		expect(weather.time).to eq(Time.at(data[:dt]).strftime('%H:%M:%S'))
		expect(weather.icon).to eq(data[:weather][0][:icon])
		expect(weather.temperature).to eq(data[:temp])
	end
end