		class InfosController < ApplicationController
			def index
				@infos = Info.paginate(:page => params[:page], :per_page => 10)
			end

			def new
				@info = Info.new
			end

			def create
				@info = Info.new(params[:info])
				if @info.save
					redirect_to infos_path
				else
					redirect_to new_info_path
				end
			end

			def edit
				@info = Info.find(params[:id])
			end

			def show
				@info = Info.find(params[:id])
			end
			
			def update
				@info = Info.find(params[:id])
				if @info.update_attributes(params[:info])
					redirect_to infos_path
				else
					redirect_to :action => 'edit', :id => @info.id
				end
			end

			def destroy
				@info = Info.find(params[:id])
				@info.destroy
				redirect_to infos_path
			end
		end