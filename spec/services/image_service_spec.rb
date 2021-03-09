require 'rails_helper'

describe ImageService, :vcr do
	describe "class methods" do
		it '::random_image' do
			data = ImageService.search_image("Boulder,co")

			expect(data).to be_a Hash

			expect(data[:results][0]).to have_key(:urls)
			expect(data[:results][0]).to have_key(:links)
			expect(data[:results][0]).to have_key(:user)
			expect(data[:results][0][:urls]).to be_a Hash
			expect(data[:results][0][:urls].count).to eq(5)

			data[:results][0][:urls].each do |key, url|
				expect([:raw, :full, :regular, :small, :thumb]).to include(key)
				expect(url).to be_a String
			end

			data[:results][0][:user][:links].each do |key, link|
				expect(data[:results][0][:user][:links]).to include(key)
				expect(link).to be_a String
			end
		end
	end
end
