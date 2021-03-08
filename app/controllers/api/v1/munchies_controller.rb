class Api::V1::MunchiesController < ApplicationController
	def index
		if params[:start].present? && params[:destination].present? && params[:food].present?
			munchie = MunchieFacade.create_food_itinerary(params[:start], params[:destination], params[:food])
			render json: MunchieSerializer.new(munchie)
		else
			render json: { error: "Invalid parameters - please refer to documentation for the correct request format."}
		end
	end
end
