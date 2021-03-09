require 'rails_helper'

describe Image, :vcr do
	it 'exists and has attributes' do
		location = "Denver,co"
		image_data = ImageService.search_image(location)[:results][0]

		image = Image.new(image_data, "Denver,co")

		expect(image).to be_an_instance_of(Image)
		expect(image.image).to be_a Hash
		expect(image.image[:location]).to eq(location)
		expect(image.image[:urls].count).to eq(5)
		image.image[:urls].values.each do |value|
			expect(value).to be_a String
		end
		expect(image.credit).to be_a Hash
		expect(image.credit.keys.count).to eq(3)
		expect(image.credit[:profile_img]).to be_a String
		expect(image.credit[:author]).to eq(image_data[:user][:username])
		expect(image.credit[:links]).to eq(image_data[:user][:links][:html])
	end
end