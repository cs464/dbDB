class PursuingsController < ApplicationController
	def index
		@pursuings = Pursuing.paginate(:page => params[:page], :per_page => 10)
	end

	def new
		@pursuing = Pursuing.new
	end
end
