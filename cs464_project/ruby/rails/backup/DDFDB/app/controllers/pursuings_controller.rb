class PursuingsController < ApplicationController
  def index
    @pursuings = Pursuing.paginate(:page => params[:page], :per_page => 10)
  end
end