require 'rails_helper'

describe "Users API" do
	describe "Happy path" do
		it "creates a new user" do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
							"email": "test@example.com",
							"password": "password",
							"password_confirmation": "password"
						}

			post '/api/v1/users', headers: headers, params: body.to_json

			user  = JSON.parse(response.body, symbolize_names: true)

			expect(response).to be_successful
			expect(response.status).to eq(201)

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
		it 'returns error if email is already taken' do
			User.create(email: "test@gmail.com", password: "strong_password")
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"email": "test@gmail.com",
				"password": "password",
				"password_confirmation": "password"
			}

			post '/api/v1/users', headers: headers, params: body.to_json

			expect(response).to_not be_successful
			expect(response.status).to eq(400)

			user = JSON.parse(response.body, symbolize_names: true)

			expect(user).to be_a(Hash)
			expect(user[:error]).to be_a(String)
			expect(user[:error]).to eq("Email is taken, missing, or password fields don't match.")
		end

		it 'returns error if email is missing' do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"email": "",
				"password": "password",
				"password_confirmation": "password"
			}

			post '/api/v1/users', headers: headers, params: body.to_json

			expect(response).to_not be_successful
			expect(response.status).to eq(400)

			user = JSON.parse(response.body, symbolize_names: true)

			expect(user).to be_a(Hash)
			expect(user[:error]).to be_a(String)
			expect(user[:error]).to eq("Email is taken, missing, or password fields don't match.")
		end

		it 'returns error if password does not match confirmation' do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"email": "test@gmail.com",
				"password": "password",
				"password_confirmation": "wrong"
			}

			post '/api/v1/users', headers: headers, params: body.to_json

			expect(response).to_not be_successful
			expect(response.status).to eq(400)

			user = JSON.parse(response.body, symbolize_names: true)

			expect(user).to be_a(Hash)
			expect(user[:error]).to be_a(String)
			expect(user[:error]).to eq("Email is taken, missing, or password fields don't match.")
		end

		it 'returns an error if password is missing' do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			body = {
				"email": "test@gmail.com",
				"password": "",
				"password_confirmation": "wrong"
			}

			post '/api/v1/users', headers: headers, params: body.to_json

			expect(response).to_not be_successful
			expect(response.status).to eq(400)

			user = JSON.parse(response.body, symbolize_names: true)

			expect(user).to be_a(Hash)
			expect(user[:error]).to be_a(String)
			expect(user[:error]).to eq("Email is taken, missing, or password fields don't match.")
		end

		it 'returns error if user data is sent as query params' do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

			post '/api/v1/users?email=test@example.com&password=password&password_confirmation=password', headers: headers, params: body.to_json

			expect(response).to_not be_successful
			expect(response.status).to eq(400)

			user = JSON.parse(response.body, symbolize_names: true)

			expect(user).to be_a(Hash)
			expect(user[:error]).to be_a(String)
			expect(user[:error]).to eq("Data must be sent in request body.")
		end
	end
end