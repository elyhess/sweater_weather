require 'rails_helper'

describe "Backgrounds API" do
	describe "Happy path" do
		it "gets an image given a location", :vcr do
			headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
			get '/api/v1/backgrounds?location=Boulder,co', headers: headers

			expect(response).to be_successful
			data = JSON.parse(response.body, symbolize_names: true)

			expect(response).to be_successful

			expect(data).to be_a(Hash)
			expect(data).to have_key(:data)
			expect(data[:data]).to be_a(Hash)
			expect(data[:data]).to have_key(:id)
			expect(data[:data][:id]).to eq(nil)
			expect(data[:data]).to have_key(:type)
			expect(data[:data][:type]).to eq('image')
			expect(data[:data]).to have_key(:attributes)
			expect(data[:data][:attributes]).to be_a(Hash)
			expect(data[:data][:attributes].size).to eq(2)

			expect(data[:data][:attributes][:image]).to have_key(:location)
			expect(data[:data][:attributes][:image][:location]).to be_a(String)
			expect(data[:data][:attributes][:image]).to have_key(:urls)
			expect(data[:data][:attributes][:image][:urls]).to be_a(Hash)
			expect(data[:data][:attributes][:image][:urls].keys).to eq([:raw, :full, :regular, :small, :thumb])
			data[:data][:attributes][:image][:urls].values.each do |value|
				expect(value).to be_a String
			end

			expect(data[:data][:attributes][:credit]).to have_key(:author)
			expect(data[:data][:attributes][:credit][:author]).to be_a(String)
			expect(data[:data][:attributes][:credit]).to have_key(:profile_img)
			expect(data[:data][:attributes][:credit][:profile_img]).to be_a(String)
			expect(data[:data][:attributes][:credit][:links]).to be_a(String)
		end
	end

	describe "Sad Path" do
		it 'returns an error if the Unsplash API is unavailable' do
			stub_get_json("https://api.unsplash.com/search/photos?client_id=#{ENV['UNSPLASH_API_KEY']}&content_filter=high&page=1&per_page=1&query=Boulder,co", 503)

			get '/api/v1/backgrounds?location=Boulder,co'

			expect(response.status).to eq(503)
			data = JSON.parse(response.body, symbolize_names: true)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("API currently unavailable. Hold tight, we're working on it!")
		end

		it 'returns error if location param is not present' do
			get '/api/v1/backgrounds'

			data = JSON.parse(response.body, symbolize_names: true)
			expect(response.status).to eq(400)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("Location missing or incorrectly entered.")
		end
		#
		it 'returns error if location param is blank' do
			get '/api/v1/backgrounds?location'

			data = JSON.parse(response.body, symbolize_names: true)
			expect(response.status).to eq(400)
			expect(data).to be_a(Hash)
			expect(data[:error]).to be_a(String)
			expect(data[:error]).to eq("Location missing or incorrectly entered.")
		end

	end
end