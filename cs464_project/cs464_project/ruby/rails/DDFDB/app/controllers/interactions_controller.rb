class InteractionsController < ApplicationController
                  # displays table (returns HTML, manually formatted by CSS API)
                  def index
                    @interactions = Interaction.paginate(:page => params[:page], :per_page => 10)
                  end
                  
                  # instantiates interaction object
                  def new
                    @interaction = Interaction.new
                  end

                  # inserts new tuple into DB
                  def create
                    @interaction = Interaction.new(params[:interaction])
                    if @interaction.save
                      redirect_to interactions_path
                    else
                      redirect_to new_interaction_path
                    end
                  end

                  # edits tuple attributes
                  def edit
                    @interaction = Interaction.find(params[:id])
                  end
                  
                  # selects/displays individual tuple
                  def show
                    @interaction = Interaction.find(params[:id])
                  end

                  # commits edit to DB
                  def update
                    @interaction = Interaction.find(params[:id])
                    if @interaction.update_attributes(params[:interaction])
                      redirect_to interactions_path
                    else
                      redirect_to :action => 'edit', :id => @interaction.id
                    end
                  end

                  # deletes tuple from DB
                  def destroy
                    @interaction = Interaction.find(params[:id])
                    @interaction.destroy
                    redirect_to interactions_path
                  end

                  # queries a list of all distinct locations all users have had interactions in past month
                  def distinct
                    @interactiondistinct = Interaction.select('location').where('DATEDIFF(CURRENT_TIMESTAMP,date_time)<33').uniq
                  end
                end
