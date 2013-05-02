# Model for Person
class Person < ActiveRecord::Base
   attr_accessible :personID, :name, :gender, :email, :phone, :contact_preference, :religion, :politics, :dob, :compatibility
end
