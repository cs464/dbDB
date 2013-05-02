		class InterestsController < ApplicationController
			def index
				@interests = Interest.paginate(:page => params[:page], :per_page => 10)
			end
			
			def new
				@interest = Interest.new
			end

			def create
				@interest = Interest.new(params[:interest])
				if @interest.save
					redirect_to interests_path
				else
					redirect_to new_interest_path
				end
			end

			def edit
				@interest = Interest.find(params[:id])
			end

			def show
				@interest = Interest.find(params[:id])
			end

			def update
				@interest = Interest.find(params[:id])
				if @interest.update_attributes(params[:interest])
					redirect_to interests_path
				else
					redirect_to :action => 'edit', :id => @interest.id
				end
			end

			def destroy
				@interest = Interest.find(params[:id])
				@interest.destroy
				redirect_to interests_path
			end


			def search
				@interest = Interest.find(params[:id])
			end

			def confirm
			end
		end