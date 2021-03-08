class Api::V1::SessionsController < ApplicationController

	def create
		if request.query_parameters.empty?
			user = User.find_by(email: params[:email])
			if user && user.authenticate(params[:password])
				render json: UsersSerializer.new(user)
			else
				render json: { error: "Incorrect credentials." }, status: :bad_request
			end
		else
			render json: { error: "User data must be sent in request body."}, status: :bad_request
		end
	end

end