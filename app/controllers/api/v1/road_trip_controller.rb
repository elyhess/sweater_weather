class Api::V1::RoadTripController < ApplicationController
	before_action :reject_query_params, only: [:create]

	def create
		user = User.find_by(api_key: trip_params[:api_key])
		if user.present?
			if user.present? && params[:origin].present? && params[:destination].present?
				road_trip = RoadTripFacade.create_road_trip(params[:origin], params[:destination])
				render json: RoadtripSerializer.new(road_trip), status: :created
			else
				render json: { error: "Origin & destination must both be present in request." }, status: :bad_request
			end
		else
			render json: { error: "Invalid API key." }, status: :unauthorized
		end
	end

	private

	def trip_params
		params.permit(:origin, :destination, :api_key)
	end

end
