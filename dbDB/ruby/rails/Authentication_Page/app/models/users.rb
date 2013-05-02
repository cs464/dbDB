class Users < ActiveRecord::Base
  attr_accessible :email, :encrypted_password, :salt, :username
end
