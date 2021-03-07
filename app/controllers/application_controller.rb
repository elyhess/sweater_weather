class ApplicationController < ActionController::API
	rescue_from JSON::ParserError, with: :json_render_failure

	def json_render_failure
		render json: { error: "API currently unavailable. Hold tight, we're working on it!"}, status: 503
	end

end
