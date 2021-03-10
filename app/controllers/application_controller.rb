class ApplicationController < ActionController::API
	rescue_from JSON::ParserError, with: :json_render_failure
	rescue_from ArgumentError, with: :bad_coordinates
	rescue_from ActiveRecord::RecordNotFound, with: :invalid_api_key

	def json_render_failure
		render json: { error: "API currently unavailable. Hold tight, we're working on it!" }, status: :service_unavailable
	end

	def bad_coordinates
		render json: { error: "Please enter a valid location" }, status: :bad_request
	end

	def reject_query_params
		unless request.query_parameters.empty?
			render json: { error: "Data must be sent in request body." }, status: :bad_request
		end
	end

	def invalid_api_key
		render json: { error: "Invalid API key." }, status: :unauthorized
	end

end
