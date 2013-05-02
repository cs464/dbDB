class Interaction < ActiveRecord::Base
  attr_accessible :interactionID, :impression, :date_time, :medium, :location, :personID
end
