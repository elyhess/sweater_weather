require 'rails_helper'

describe Forecast, :vcr do
	it 'exists and has attributes' do
		data = ForecastService.weather_report(40.015831, -105.27927)

		current = ForecastFacade.current_weather(data)
		daily = ForecastFacade.daily_weather(data)
		hourly = ForecastFacade.hourly_weather(data)

		weather = Forecast.new(current, daily, hourly)

		expect(weather).to be_an_instance_of(Forecast)
		expect(weather.current_weather).to eq(current)
		expect(weather.daily_weather).to eq(daily)
		expect(weather.hourly_weather).to eq(hourly)
	end
end