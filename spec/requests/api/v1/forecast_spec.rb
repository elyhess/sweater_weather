require 'rails_helper'

describe "Forecast API" do
	describe "Happy path" do
		it "gets weather for a location", :vcr do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
			get '/api/v1/forecast?location=Boulder,co', headers: headers

			expect(response).to be_successful
			data = JSON.parse(response.body, symbolize_names: true)

			expect(response).to be_successful

			expect(data).to be_a(Hash)
			expect(data).to have_key(:data)
			expect(data[:data]).to be_a(Hash)
			expect(data[:data]).to have_key(:id)
			expect(data[:data][:id]).to eq(nil)
			expect(data[:data]).to have_key(:type)
			expect(data[:data][:type]).to eq('forecast')
			expect(data[:data]).to have_key(:attributes)
			expect(data[:data][:attributes]).to be_a(Hash)


			expect(data[:data][:attributes][:current_weather]).to have_key(:datetime)
			expect(data[:data][:attributes][:current_weather][:datetime]).to be_a(String)
			expect(data[:data][:attributes][:current_weather]).to have_key(:sunrise)
			expect(data[:data][:attributes][:current_weather][:sunrise]).to be_a(String)
			expect(data[:data][:attributes][:current_weather]).to have_key(:sunset)
			expect(data[:data][:attributes][:current_weather][:sunset]).to be_a(String)
			expect(data[:data][:attributes][:current_weather]).to have_key(:temperature)
			expect(data[:data][:attributes][:current_weather][:temperature]).to be_a(Float)
			expect(data[:data][:attributes][:current_weather]).to have_key(:feels_like)
			expect(data[:data][:attributes][:current_weather][:feels_like]).to be_a(Float)
			expect(data[:data][:attributes][:current_weather]).to have_key(:humidity)
			expect(data[:data][:attributes][:current_weather][:humidity]).to be_a(Numeric)
			expect(data[:data][:attributes][:current_weather]).to have_key(:uvi)
			expect(data[:data][:attributes][:current_weather][:uvi]).to be_a(Numeric)
			expect(data[:data][:attributes][:current_weather]).to have_key(:conditions)
			expect(data[:data][:attributes][:current_weather][:conditions]).to be_a(String)
			expect(data[:data][:attributes][:current_weather]).to have_key(:icon)
			expect(data[:data][:attributes][:current_weather][:icon]).to be_a(String)

			expect(data[:data][:attributes][:daily_weather]).to be_a(Array)
			expect(data[:data][:attributes][:daily_weather].count).to eq(5)
			expect(data[:data][:attributes][:daily_weather][0]).to have_key(:date)
			expect(data[:data][:attributes][:daily_weather][0][:date]).to be_a(String)
			expect(data[:data][:attributes][:daily_weather][0]).to have_key(:sunrise)
			expect(data[:data][:attributes][:daily_weather][0][:sunrise]).to be_a(String)
			expect(data[:data][:attributes][:daily_weather][0]).to have_key(:sunset)
			expect(data[:data][:attributes][:daily_weather][0][:sunset]).to be_a(String)
			expect(data[:data][:attributes][:daily_weather][0]).to have_key(:max_temp)
			expect(data[:data][:attributes][:daily_weather][0][:max_temp]).to be_a(Float)
			expect(data[:data][:attributes][:daily_weather][0]).to have_key(:min_temp)
			expect(data[:data][:attributes][:daily_weather][0][:min_temp]).to be_a(Float)
			expect(data[:data][:attributes][:daily_weather][0]).to have_key(:conditions)
			expect(data[:data][:attributes][:daily_weather][0][:conditions]).to be_a(String)
			expect(data[:data][:attributes][:daily_weather][0]).to have_key(:icon)
			expect(data[:data][:attributes][:daily_weather][0][:icon]).to be_a(String)

			expect(data[:data][:attributes][:hourly_weather]).to be_a(Array)
			expect(data[:data][:attributes][:hourly_weather].count).to eq(8)
			expect(data[:data][:attributes][:hourly_weather][0]).to have_key(:time)
			expect(data[:data][:attributes][:hourly_weather][0][:time]).to be_a(String)
			expect(data[:data][:attributes][:hourly_weather][0]).to have_key(:temperature)
			expect(data[:data][:attributes][:hourly_weather][0][:temperature]).to be_a(Float)
			expect(data[:data][:attributes][:hourly_weather][0]).to have_key(:conditions)
			expect(data[:data][:attributes][:hourly_weather][0][:conditions]).to be_a(String)
			expect(data[:data][:attributes][:hourly_weather][0]).to have_key(:icon)
			expect(data[:data][:attributes][:hourly_weather][0][:icon]).to be_a(String)

			expect(data[:data][:attributes][:hourly_weather][0]).to_not have_key(:wind_speed)
			expect(data[:data][:attributes][:hourly_weather][0]).to_not have_key(:wind_direction)
		end
	end

	describe "Sad Path" do
		it 'returns an error if the MapQuest API is unavailable' do
			stub_get_json("http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=Boulder,co", 503)

			get '/api/v1/forecast?location=Boulder,co'

			expect(response.status).to eq(503)
			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("API currently unavailable. Hold tight, we're working on it!")
		end

		it 'returns an error if the OpenWeather API is unavailable' do
			stub_get_json("http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=Boulder,co", 200)
			stub_get_json("https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['WEATHER_API_KEY']}&lat=40.015831&lon=-105.27927", 503)

			get '/api/v1/forecast?location=Boulder,co'

			expect(response.status).to eq(503)
			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("API currently unavailable. Hold tight, we're working on it!")
		end

		it 'returns error if location param is not present' do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
			get '/api/v1/forecast', headers: headers

			expect(response.status).to eq(400)
			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("Location missing or incorrectly entered.")
		end

		it 'returns error if location param is blank' do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
			get '/api/v1/forecast?location', headers: headers

			expect(response.status).to eq(400)
			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("Location missing or incorrectly entered.")
		end

		it 'returns an error if the location is invalid / cannot be found', :vcr do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
			get '/api/v1/forecast?location=notareal,location,atall', headers: headers

			expect(response.status).to eq(400)
			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("Please enter a valid location")
		end
	end
end