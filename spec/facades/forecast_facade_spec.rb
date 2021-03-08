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

		it '::food_forecast' do
			food_forecast = ForecastFacade.food_forecast(40.015831, -105.27927)

			expect(food_forecast).to be_an(Hash)

			expect(food_forecast).to be_a Hash
			expect(food_forecast).to have_key(:lat)
			expect(food_forecast).to have_key(:lon)
			expect(food_forecast).to have_key(:timezone)
			expect(food_forecast).to have_key(:timezone_offset)
			expect(food_forecast).to have_key(:current)
			expect(food_forecast).to have_key(:hourly)
			expect(food_forecast).to have_key(:daily)
		end
	end
end