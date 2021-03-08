require 'rails_helper'

describe "Sessions API" do
	describe "Happy path" do
		it "Registered users can log in successfully" do
			user = User.create!(email: "test@example.com", password: "password")
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"email": "test@example.com",
				"password": "password"
			}

			post '/api/v1/sessions', headers: headers, params: body.to_json

			user  = JSON.parse(response.body, symbolize_names: true)

			expect(response).to be_successful
			expect(response.status).to eq(200)

			expect(user).to be_a Hash
			expect(user[:data].keys).to eq([:id, :type, :attributes])
			expect(user[:data][:id]).to eq(User.last.id.to_s)
			expect(user[:data][:type]).to eq("users")
			expect(user[:data][:attributes]).to be_a Hash
			expect(user[:data][:attributes][:email]).to be_a String
			expect(user[:data][:attributes][:email]).to eq(User.last.email)
			expect(user[:data][:attributes][:api_key]).to be_a String
			expect(user[:data][:attributes][:api_key]).to eq(User.last.api_key)
		end
	end

	describe "Sad Path" do
		it 'returns error if email is missing' do
			user = User.create!(email: "test@example.com", password: "password")

			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"email": "",
				"password": "password",
				"password_confirmation": "password"
			}

			post '/api/v1/sessions', headers: headers, params: body.to_json

			expect(response).to_not be_successful
			expect(response.status).to eq(400)

			user = JSON.parse(response.body, symbolize_names: true)

			expect(user).to be_a(Hash)
			expect(user[:error]).to be_a(String)
			expect(user[:error]).to eq("Incorrect credentials.")
		end

		it 'returns error if password incorrect' do
			user = User.create!(email: "test@example.com", password: "password")

			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"email": "test@gmail.com",
				"password": "xxxxxxx",
				"password_confirmation": "xxxxxxx"
			}

			post '/api/v1/sessions', headers: headers, params: body.to_json

			expect(response).to_not be_successful
			expect(response.status).to eq(400)

			user = JSON.parse(response.body, symbolize_names: true)

			expect(user).to be_a(Hash)
			expect(user[:error]).to be_a(String)
			expect(user[:error]).to eq("Incorrect credentials.")
		end

		it 'returns an error if password is missing' do
			user = User.create!(email: "test@example.com", password: "password")

			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"email": "test@gmail.com",
				"password": "",
				"password_confirmation": "wrong"
			}

			post '/api/v1/sessions', headers: headers, params: body.to_json

			expect(response).to_not be_successful
			expect(response.status).to eq(400)

			user = JSON.parse(response.body, symbolize_names: true)

			expect(user).to be_a(Hash)
			expect(user[:error]).to be_a(String)
			expect(user[:error]).to eq("Incorrect credentials.")
		end

		it 'returns error if credentials are sent as query params' do
			user = User.create!(email: "test@example.com", password: "password")

			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			post '/api/v1/sessions?email=test@example.com&password=password', headers: headers, params: body.to_json

			expect(response).to_not be_successful
			expect(response.status).to eq(400)

			user = JSON.parse(response.body, symbolize_names: true)

			expect(user).to be_a(Hash)
			expect(user[:error]).to be_a(String)
			expect(user[:error]).to eq("User data must be sent in request body.")
		end
	end
end