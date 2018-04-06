class UsersController < ApplicationController
	before_action :set_user
	def show
		@reviews = []
		@reviews = @user.reviews if @user.mechanical
	end

	private

	def set_user
		@user = User.find(params[:id])
	end
end
