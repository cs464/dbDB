		class InterestsController < ApplicationController
 			def index
    				@interests = Info.paginate(:page => params[:page], :per_page => 10)
 			end
		end