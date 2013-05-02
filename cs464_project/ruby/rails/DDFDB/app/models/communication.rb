# Model for Communication
class Communication < ActiveRecord::Base
  attr_accessible :communicationID, :content, :theme, :interactionID
end