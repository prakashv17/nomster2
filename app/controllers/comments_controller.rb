class CommentsController < ApplicationController
	before_action :authenticate_user!
	def create
		@places = Place.find(params[:place_id])
		@places.comments.create(comment_params.merge(user: current_user))
		redirect_to place_path(@places)
	end

	private

	def comment_params
		params.require(:comment).permit(:message, :rating)
	end
end
