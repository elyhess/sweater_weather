class Api::V1::ForecastController < ApplicationController
	def index
		if params[:location].present?
			forecast = ForecastFacade.fetch_forecast(params[:location])
			render json: ForecastSerializer.new(forecast)
		else
			render json: { error: "Location missing or incorrectly entered."}, status: :bad_request
		end
	end
end