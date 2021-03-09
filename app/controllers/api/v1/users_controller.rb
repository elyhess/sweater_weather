class Api::V1::UsersController < ApplicationController
	before_action :reject_query_params, only: [:create]

	def create
		user = User.new(user_params)
		if user.save
			render json: UsersSerializer.new(user), status: :created
		else
			render json: { error: "Email is taken, missing, or password fields don't match." }, status: :bad_request
		end
	end

	private

	def user_params
		params.permit(:email, :password, :password_confirmation)
	end

end