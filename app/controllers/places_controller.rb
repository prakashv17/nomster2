class PlacesController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

	def index
		@places = Place.all
		@places = Place.order("created_at ASC").paginate(:page => params[:page], :per_page => 5)
	end

	def new
		@places = Place.new
	end

	def create
		@places = current_user.places.create(place_params)
		if @places.valid?
			redirect_to root_path
		else
			render :new, status: :unprocessable_entity
		end
		
	end

	def show
		@places = Place.find(params[:id])
	end

	def edit
		@places = Place.find(params[:id])

		if @places.user != current_user
			return render text: 'Not allowed', status: :forbidden
		end
	end

	def update
		@places = Place.find(params[:id])

		if @places.user != current_user
			return render text: 'Not allowed', status: :forbidden
		end

		@places.update_attributes(place_params)
		if @places.valid?
			redirect_to root_path
		else
			render :edit, status: :unprocessable_entity
		end
	end

	def destroy
		@places = Place.find(params[:id])

		if @places.user != current_user
			return render text: 'Not allowed', status: :forbidden
		end

		@places.destroy
		redirect_to root_path
	end

	private

	def place_params
		params.require(:place).permit(:name, :address, :description)
	end


end
