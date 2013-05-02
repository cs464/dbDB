		class InterestsController < ApplicationController
                  # displays table (returns HTML, manually formatted by CSS API)
                  def index
                    @interests = Interest.paginate(:page => params[:page], :per_page => 10)
                  end
                  
                  # instantiates interest object
                  def new
                    @interest = Interest.new
                  end

                  # inserts new tuple into DB
                  def create
                    @interest = Interest.new(params[:interest])
                    if @interest.save
                      redirect_to interests_path
                    else
                      redirect_to new_interest_path
                    end
                  end
                  
                  # edits tuple attributes
                  def edit
                    @interest = Interest.find(params[:id])
                  end

                  # selects/displays individual tuple
                  def show
                    @interest = Interest.find(params[:id])
                  end

                  # commits edit to DB
                  def update
                    @interest = Interest.find(params[:id])
                    if @interest.update_attributes(params[:interest])
                      redirect_to interests_path
                    else
                      redirect_to :action => 'edit', :id => @interest.id
                    end
                  end
                  
                  # deletes tuple from DB
                  def destroy
                    @interest = Interest.find(params[:id])
                    @interest.destroy
                    redirect_to interests_path
                  end
                end
