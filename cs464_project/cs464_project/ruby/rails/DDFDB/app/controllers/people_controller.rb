		class PeopleController < ApplicationController
                  # displays table (returns HTML, manually formatted by CSS API)
                  def index
                  	@people = Person.paginate(:page => params[:page], :per_page => 10)
                  end

                  # lists people being pursued by multiple users
                  def groupby
                  	@persongroup = Person.select('name, count(*) as n_users').group('name').having('n_users>1')
                  end
                  
                  # instantiates person object
                  def new
                  	@person = Person.new
                  end

                  # inserts new tuple into DB
                  def create
                  	@person = Person.new(params[:person])
                  	if @person.save
                  		redirect_to people_path
                  	else
                  		redirect_to new_person_path
                  	end
                  end

                  # edits tuple attributes
                  def edit
                  	@person = Person.find(params[:id])
                  end

                  # selects/displays individual tuple
                  def show
                  	@person = Person.find(params[:id])
                  end
                  
                  # commits edit to DB
                  def update
                  	@person = Person.find(params[:id])
                  	if @person.update_attributes(params[:person])
                  		redirect_to people_path
                  	else
                  		redirect_to :action => 'edit', :id => @person.id
                  	end
                  end
                  
                  # deletes tuple from DB
                  def destroy
                  	@person = Person.find(params[:id])
                  	@person.destroy
                  	redirect_to people_path
                  end
              end
