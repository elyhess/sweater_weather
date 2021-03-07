require 'rails_helper'

describe CurrentWeather, :vcr do
	it 'exists and has attributes' do
		data = ForecastService.weather_report(40.015831, -105.27927)[:current]

		weather = CurrentWeather.new(data)

		expect(weather).to be_an_instance_of(CurrentWeather)
		expect(weather.conditions).to eq(data[:weather][0][:description])
		expect(weather.datetime).to eq(Time.at(data[:dt]).getlocal.to_s)
		expect(weather.feels_like).to eq(data[:feels_like])
		expect(weather.humidity).to eq(data[:humidity])
		expect(weather.icon).to eq(data[:weather][0][:icon])
		expect(weather.sunrise).to eq(Time.at(data[:sunrise]).getlocal.to_s)
		expect(weather.sunset).to eq(Time.at(data[:sunset]).getlocal.to_s)
		expect(weather.temperature).to eq(data[:temp])
		expect(weather.uvi).to eq(data[:uvi])
		expect(weather.visibility).to eq(data[:visibility])
	end
end