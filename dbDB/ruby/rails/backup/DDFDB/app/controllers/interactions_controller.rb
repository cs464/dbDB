		class InteractionsController < ApplicationController
 			def index
    				@interactions = Interaction.paginate(:page => params[:page], :per_page => 10)
 			end
		end