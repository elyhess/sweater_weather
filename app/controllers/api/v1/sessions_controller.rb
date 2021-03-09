class Api::V1::SessionsController < ApplicationController
	before_action :reject_query_params, only: [:create]

	def create
		user = User.find_by(email: params[:email])
		if user.present? && user.authenticate(params[:password])
			render json: UsersSerializer.new(user)
		else
			render json: { error: "Incorrect credentials." }, status: :bad_request
		end
	end

end