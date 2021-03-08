require 'rails_helper'

describe "Munchies API" do
	describe "Happy path" do
		it "gets a food itinerary based on location and food type", :vcr do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
			get "/api/v1/munchies?start=boulder,co&destination=denver,co&food=burger", headers: headers

			expect(response).to be_successful
			data = JSON.parse(response.body, symbolize_names: true)

			expect(data).to be_a(Hash)
			expect(data[:data]).to be_a(Hash)
			expect(data[:data].keys).to eq([:id, :type, :attributes])
			expect(data[:data][:id]).to be_nil
			expect(data[:data][:type]).to eq("munchie")
			expect(data[:data][:attributes].keys).to eq([:destination_city, :travel_time, :forecast, :restaurant])
			expect(data[:data][:attributes][:destination_city]).to be_a(String)
			expect(data[:data][:attributes][:travel_time]).to be_a(String)
			expect(data[:data][:attributes][:forecast]).to be_a(Hash)
			expect(data[:data][:attributes][:forecast].keys).to eq([:summary, :temperature])
			expect(data[:data][:attributes][:forecast][:summary]).to be_a(String)
			expect(data[:data][:attributes][:forecast][:temperature]).to be_a(String)
			expect(data[:data][:attributes][:restaurant]).to be_a(Hash)
			expect(data[:data][:attributes][:restaurant].keys).to eq([:name, :address])
			expect(data[:data][:attributes][:restaurant][:name]).to be_a(String)
			expect(data[:data][:attributes][:restaurant][:address]).to be_a(String)
		end
	end

	describe "Sad Path" do
		it 'returns an error if the MapQuest API is unavailable' do
			stub_get_json("http://www.mapquestapi.com/directions/v2/route?key=#{ENV['MAPQUEST_API_KEY']}&from=boulder,co&to=denver,co", 503)

			get '/api/v1/munchies?start=boulder,co&destination=denver,co&food=burger'

			expect(response.status).to eq(503)
			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("API currently unavailable. Hold tight, we're working on it!")
		end

		it 'returns an error if the OpenWeather API is unavailable' do
			stub_get_json("http://www.mapquestapi.com/directions/v2/route?key=#{ENV['MAPQUEST_API_KEY']}&from=boulder,co&to=denver,co", 200)
			stub_get_json("https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['WEATHER_API_KEY']}&lat=40.015831&lon=-105.27927", 503)

			get '/api/v1/munchies?start=boulder,co&destination=denver,co&food=burger'

			expect(response.status).to eq(503)
			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("API currently unavailable. Hold tight, we're working on it!")
		end

		it 'returns error if no params present' do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
			get '/api/v1/munchies', headers: headers

			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("Invalid parameters - please refer to documentation for the correct request format.")
		end

		it 'returns error if start param is blank' do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
			get '/api/v1/munchies?destination=denver,co&food=burger', headers: headers

			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("Invalid parameters - please refer to documentation for the correct request format.")
		end

		it 'returns error if destination param is blank' do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
			get '/api/v1/munchies?start=boulder,co&food=burger', headers: headers

			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("Invalid parameters - please refer to documentation for the correct request format.")
		end

		it 'returns error if food param is blank' do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
			get '/api/v1/munchies?start=boulder,co&destination=denver,co', headers: headers

			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("Invalid parameters - please refer to documentation for the correct request format.")
		end

	end
end