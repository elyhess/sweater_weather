class Api::V1::BackgroundsController < ApplicationController
	def index
		if params[:location].present?
			background_image = ImageFacade.create_image(params[:location])
			render json: ImageSerializer.new(background_image)
		else
			render json: { error: "Location missing or incorrectly entered."}, status: :bad_request
		end
	end
end