require 'rails_helper'

describe ForecastFacade, :vcr do
	describe "Class Methods" do
		it '::fetch_forecast' do
			forecast = ForecastFacade.fetch_forecast("Boulder,co")

			expect(forecast).to be_an_instance_of(Forecast)
		end

		it '::retrieve_weather' do
			forecast = ForecastFacade.retrieve_weather("Boulder,co")

			expect(forecast).to be_a Hash
			expect(forecast).to have_key(:lat)
			expect(forecast).to have_key(:lon)
			expect(forecast).to have_key(:timezone)
			expect(forecast).to have_key(:timezone_offset)
			expect(forecast).to have_key(:current)
			expect(forecast).to have_key(:hourly)
			expect(forecast).to have_key(:daily)
		end

		it '::current_weather' do
			forecast = ForecastFacade.retrieve_weather("Boulder,co")

			expect(ForecastFacade.current_weather(forecast)).to be_an_instance_of(CurrentWeather)
		end

		it '::hourly_weather' do
			forecast = ForecastFacade.retrieve_weather("Boulder,co")

			expect(ForecastFacade.hourly_weather(forecast)).to be_an(Array)
			expect(ForecastFacade.hourly_weather(forecast).first).to be_an_instance_of(HourlyWeather)
		end

		it '::daily_weather' do
			forecast = ForecastFacade.retrieve_weather("Boulder,co")

			expect(ForecastFacade.daily_weather(forecast)).to be_an(Array)
			expect(ForecastFacade.daily_weather(forecast).first).to be_an_instance_of(DailyWeather)
		end

		it '::weather_at_eta' do
			travel_time = { formatted_time: "00:34:12",
			                unix_time: 123123 }
			forecast = ForecastFacade.weather_at_eta("Boulder,co", travel_time)

			expect(forecast).to be_a Hash
			expect(forecast).to have_key(:dt)
			expect(forecast).to have_key(:temp)
			expect(forecast).to have_key(:feels_like)
			expect(forecast).to have_key(:pressure)
			expect(forecast).to have_key(:humidity)
			expect(forecast).to have_key(:dew_point)
			expect(forecast).to have_key(:uvi)
			expect(forecast).to have_key(:clouds)
			expect(forecast).to have_key(:visibility)
			expect(forecast).to have_key(:wind_speed)
			expect(forecast).to have_key(:wind_deg)
			expect(forecast).to have_key(:weather)
			expect(forecast[:weather][0]).to be_a(Hash)
			expect(forecast[:weather][0].keys).to eq([:id, :main, :description, :icon])
			expect(forecast).to have_key(:pop)
		end
	end
end