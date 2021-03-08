require 'rails_helper'

describe ImageService, :vcr do
	describe "class methods" do
		it '::random_image' do
			data = ImageService.random_image("Boulder,co")

			expect(data.first).to be_a Hash

			expect(data.first).to have_key(:urls)
			expect(data.first).to have_key(:links)
			expect(data.first).to have_key(:user)
			expect(data.first[:urls]).to be_a Hash
			expect(data.first[:urls].count).to eq(5)

			data.first[:urls].each do |key, url|
				expect([:raw, :full, :regular, :small, :thumb]).to include(key)
				expect(url).to be_a String
			end

			data.first[:user][:links].each do |key, link|
				expect(data.first[:user][:links]).to include(key)
				expect(link).to be_a String
			end
		end
	end
end
