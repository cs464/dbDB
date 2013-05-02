		class CommunicationsController < ApplicationController
			def index
				@communications = Communication.paginate(:page => params[:page], :per_page => 10)
			end

			def new
				@communication = Communication.new
			end

			def create
				@communication = Communication.new(params[:communication])
				if @communication.save
					redirect_to communications_path
				else
					redirect_to new_communication_path
				end
			end

			def edit
				@communication = Communication.find(params[:id])
			end

			def show
				@communication = Communication.find(params[:id])
			end
			
			def update
				@communication = Communication.find(params[:id])
				if @communication.update_attributes(params[:communication])
					redirect_to communications_path
				else
					redirect_to :action => 'edit', :id => @communication.id
				end
			end

			def destroy
				@communication = Communication.find(params[:id])
				@communication.destroy
				redirect_to communications_path
			end
		end