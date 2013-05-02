class User < ActiveRecord::Base
   attr_accessible :username, :password_hash
end
