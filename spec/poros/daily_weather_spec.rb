require 'rails_helper'

describe DailyWeather, :vcr do
	it 'exists and has attributes' do
		data = ForecastService.weather_report(40.015831, -105.27927)[:daily].first

		weather = DailyWeather.new(data)
		expect(weather.conditions).to eq(data[:weather][0][:description])
		expect(weather.date).to eq(Time.at(data[:dt]).strftime('%Y-%m-%d'))
		expect(weather.icon).to eq(data[:weather][0][:icon])
		expect(weather.max_temp).to eq(data[:temp][:max])
		expect(weather.min_temp).to eq(data[:temp][:min])
		expect(weather.sunrise).to eq(Time.at(data[:sunrise]).getlocal.to_s)
		expect(weather.sunset).to eq(Time.at(data[:sunset]).getlocal.to_s)
	end
end