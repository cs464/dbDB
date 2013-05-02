		class PeopleController < ApplicationController
 			def index
    				@people = Person.paginate(:page => params[:page], :per_page => 10)
 			end
		end