		class CommunicationsController < ApplicationController
 			def index
    				@communications = Communication.paginate(:page => params[:page], :per_page => 10)
 			end
		end