require 'rails_helper'

describe ImageFacade, :vcr do
	describe "Class Methods" do
		it '::fetch_background' do
			image = ImageFacade.fetch_background("Denver,co")

			expect(image).to be_an_instance_of(Image)
		end
	end
end