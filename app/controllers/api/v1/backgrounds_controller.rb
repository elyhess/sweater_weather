class Api::V1::BackgroundsController < ApplicationController
	def index
		if params[:location].present?
			background_image = ImageFacade.fetch_background(params[:location])
			render json: ImageSerializer.new(background_image)
		else
			render json: { error: "Location missing or incorrectly entered."}
		end
	end
end