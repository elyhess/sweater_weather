require 'rails_helper'

describe "road_trip API" do
	describe "Happy path" do
		it "I can create a road_trip if I am authorized", :vcr do
			user = User.create!(email: "test@example.com", password: "password")
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"origin": "denver,co",
				"destination": "boulder,co",
				"api_key": "#{user.api_key}"
			}

			post '/api/v1/road_trip', headers: headers, params: body.to_json

			trip  = JSON.parse(response.body, symbolize_names: true)

			expect(response).to be_successful
			expect(response.status).to eq(201)

			expect(trip).to be_a Hash
			expect(trip[:data]).to be_a Hash
			expect(trip[:data].keys).to eq([:id, :type, :attributes])
			expect(trip[:data][:id]).to be_nil
			expect(trip[:data][:type]).to eq("roadtrip")
			expect(trip[:data][:attributes]).to be_a Hash
			expect(trip[:data][:attributes].keys).to eq([:start_city, :end_city, :travel_time, :weather_at_eta])
			expect(trip[:data][:attributes][:start_city]).to be_a String
			expect(trip[:data][:attributes][:end_city]).to be_a String
			expect(trip[:data][:attributes][:travel_time]).to be_a String
			expect(trip[:data][:attributes][:weather_at_eta]).to be_a Hash
			expect(trip[:data][:attributes][:weather_at_eta].keys).to eq([:temperature, :conditions])
			expect(trip[:data][:attributes][:weather_at_eta][:temperature]).to be_a Numeric
			expect(trip[:data][:attributes][:weather_at_eta][:conditions]).to be_a String
		end

		it 'I can create a road_trip but if the route is invalid I see that reflected in the response', :vcr do
			user = User.create!(email: "test@example.com", password: "password")
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"origin": "denver,co",
				"destination": "russia",
				"api_key": "#{user.api_key}"
			}

			post '/api/v1/road_trip', headers: headers, params: body.to_json

			trip  = JSON.parse(response.body, symbolize_names: true)

			expect(response).to be_successful
			expect(response.status).to eq(201)

			expect(trip).to be_a Hash
			expect(trip[:data]).to be_a Hash
			expect(trip[:data].keys).to eq([:id, :type, :attributes])
			expect(trip[:data][:id]).to be_nil
			expect(trip[:data][:type]).to eq("roadtrip")
			expect(trip[:data][:attributes]).to be_a Hash
			expect(trip[:data][:attributes].keys).to eq([:start_city, :end_city, :travel_time, :weather_at_eta])
			expect(trip[:data][:attributes][:start_city]).to be_a String
			expect(trip[:data][:attributes][:end_city]).to be_a String
			expect(trip[:data][:attributes][:travel_time]).to be_a String
			expect(trip[:data][:attributes][:travel_time]).to eq("Impossible route")
			expect(trip[:data][:attributes][:weather_at_eta]).to be_a Hash
			expect(trip[:data][:attributes][:weather_at_eta]).to be_empty
		end
	end

	describe "Sad Path" do
		it 'returns an error if origin is missing' do
			user = User.create!(email: "test@example.com", password: "password")
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"origin": "",
				"destination": "denver,co",
				"api_key": "#{user.api_key}"
			}

			post '/api/v1/road_trip', headers: headers, params: body.to_json

			expect(response.status).to eq(400)
			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("Origin & destination must both be present in request.")
		end

		it 'returns an error if destination is missing' do
			user = User.create!(email: "test@example.com", password: "password")
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"origin": "denver,co",
				"destination": "",
				"api_key": "#{user.api_key}"
			}

			post '/api/v1/road_trip', headers: headers, params: body.to_json

			expect(response.status).to eq(400)
			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("Origin & destination must both be present in request.")
		end

		it 'returns an error if the MapQuest API is unavailable' do
			stub_get_json("http://www.mapquestapi.com/directions/v2/route?&from=denver,co&key=#{ENV['MAPQUEST_API_KEY']}&to=russia", 503)

			user = User.create!(email: "test@example.com", password: "password")
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"origin": "denver,co",
				"destination": "russia",
				"api_key": "#{user.api_key}"
			}

			post '/api/v1/road_trip', headers: headers, params: body.to_json

			expect(response.status).to eq(503)
			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("API currently unavailable. Hold tight, we're working on it!")
		end

		it 'returns an error if the OpenWeather API is unavailable' do
			stub_get_json("http://www.mapquestapi.com/directions/v2/route?&from=denver,co&key=#{ENV['MAPQUEST_API_KEY']}&to=russia", 200)
			stub_get_json("https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['WEATHER_API_KEY']}&lat=40.015831&lon=-105.27927", 503)

			user = User.create!(email: "test@example.com", password: "password")
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"origin": "denver,co",
				"destination": "russia",
				"api_key": "#{user.api_key}"
			}

			post '/api/v1/road_trip', headers: headers, params: body.to_json

			expect(response.status).to eq(503)
			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("API currently unavailable. Hold tight, we're working on it!")
		end

		it 'returns an error if my api key is invalid' do
			user = User.create!(email: "test@example.com", password: "password")
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"origin": "denver,co",
				"destination": "boulder,co",
				"api_key": "not_a_valid_key"
			}

			post '/api/v1/road_trip', headers: headers, params: body.to_json

			trip  = JSON.parse(response.body, symbolize_names: true)

			expect(response).to_not be_successful
			expect(response.status).to eq(401)

			expect(trip).to be_a(Hash)
			expect(trip[:error]).to be_a(String)
			expect(trip[:error]).to eq("Invalid API key.")
		end

		it 'returns error if trip data is sent as query params' do
			user = User.create!(email: "test@example.com", password: "password")
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			post "/api/v1/road_trip?api_key=#{user.api_key}&origin=denver,co&destination=boulder,co", headers: headers

			expect(response).to_not be_successful
			expect(response.status).to eq(400)

			trip = JSON.parse(response.body, symbolize_names: true)

			expect(trip).to be_a(Hash)
			expect(trip[:error]).to be_a(String)
			expect(trip[:error]).to eq("Data must be sent in request body.")
		end
	end
end