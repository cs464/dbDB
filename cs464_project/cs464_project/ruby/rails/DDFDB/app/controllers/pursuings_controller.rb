class PursuingsController < ApplicationController
  # displays table (returns HTML, manually formatted by CSS API)
  def index
    @pursuings = Pursuing.paginate(:page => params[:page], :per_page => 10)
  end
  
  # instantiates pursuing object
  def new
    @pursuing = Pursuing.new
  end
end
