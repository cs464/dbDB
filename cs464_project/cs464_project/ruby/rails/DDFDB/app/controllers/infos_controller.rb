		class InfosController < ApplicationController
           # displays table (returns HTML, manually formatted by CSS API)
           def index
           	@infos = Info.paginate(:page => params[:page], :per_page => 10)
           end
           
           # instantiates info object
           def new
           	@info = Info.new
           end

            # inserts new tuple into DB
            def create
            	@info = Info.new(params[:info])
            	if @info.save
            		redirect_to infos_path
            	else
            		redirect_to new_info_path
            	end
            end
            
           # edits tuple attributes
           def edit
           	@info = Info.find(params[:id])
           end
           
            # selects/displays individual tuple
            def show
            	@info = Info.find(params[:id])
            end
            
            # commits edit to DB
            def update
            	@info = Info.find(params[:id])
            	if @info.update_attributes(params[:info])
            		redirect_to infos_path
            	else
            		redirect_to :action => 'edit', :id => @info.id
            	end
            end
            
            # deletes tuple from DB
            def destroy
            	@info = Info.find(params[:id])
            	@info.destroy
            	redirect_to infos_path
            end
        end
