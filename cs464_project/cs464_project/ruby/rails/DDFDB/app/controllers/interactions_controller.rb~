		class InteractionsController < ApplicationController
			def index
				@interactions = Interaction.paginate(:page => params[:page], :per_page => 10)
			end

			def new
				@interaction = Interaction.new
			end

			def create
				@interaction = Interaction.new(params[:interaction])
				if @interaction.save
					redirect_to interactions_path
				else
					redirect_to new_interaction_path
				end
			end

			def edit
				@interaction = Interaction.find(params[:id])
			end

			def show
				@interaction = Interaction.find(params[:id])
			end

			def update
				@interaction = Interaction.find(params[:id])
				if @interaction.update_attributes(params[:interaction])
					redirect_to interactions_path
				else
					redirect_to :action => 'edit', :id => @interaction.id
				end
			end

			def destroy
				@interaction = Interaction.find(params[:id])
				@interaction.destroy
				redirect_to interactions_path
			end


			def search
				@interaction = Interaction.find(params[:id])
			end

			def distinct
				@interactiondistinct = Interaction.select('location').where('DATEDIFF(CURRENT_TIMESTAMP,date_time)<33').uniq
			end

			def confirm
			end
		end