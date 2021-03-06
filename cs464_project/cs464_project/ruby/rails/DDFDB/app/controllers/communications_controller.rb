		class CommunicationsController < ApplicationController
           # displays table (returns HTML, manually formatted by CSS API)
           def index
           	@communications = Communication.paginate(:page => params[:page], :per_page => 10)
           end
           
            # instantiates communication object
            def new
            	@communication = Communication.new
            end
            
            # inserts new tuple into DB
            def create
            	@communication = Communication.new(params[:communication])
            	if @communication.save
            		redirect_to communications_path
            	else
            		redirect_to new_communication_path
            	end
            end
            
            # edits tuple attributes
            def edit
            	@communication = Communication.find(params[:id])
            end

            # selects/displays individual tuple
            def show
            	@communication = Communication.find(params[:id])
            end
            
            # commits edit to DB
            def update
            	@communication = Communication.find(params[:id])
            	if @communication.update_attributes(params[:communication])
            		redirect_to communications_path
            	else
            		redirect_to :action => 'edit', :id => @communication.id
            	end
            end
            
            # deletes tuple from DB
            def destroy
            	@communication = Communication.find(params[:id])
            	@communication.destroy
            	redirect_to communications_path
            end
        end
