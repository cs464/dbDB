#!/usr/bin/ruby

# Coded by Gabriel Arrillaga

require 'mysql'

def createCommunications
  themes = ['story','joke','tease','personal','question','plans','sexual','comment']
  interactionIDs = $db.query("SELECT interactionID FROM Interaction")
  numInt = interactionIDs.num_rows()

 for i in 0..10000
   thisInteraction = interactionIDs.field_seek((rand()*numInt).to_i)
   thisTheme = themes.sample
   thisContent = "totally unique and fascinating message " + i.to_s()
   results = $db.query("INSERT INTO Communication(interactionID,content,theme) VALUES ('#{thisInteraction}','#{thisTheme}','#{thisContent}')")
  end
end


begin

  $db = Mysql.new("127.0.0.1", "root", "birdistheword", "dating_db")
  # $db.query("DELETE FROM Communication;")
  createCommunications

rescue Mysql::Error => e
  puts "Error Code: #{e.errno}"
  puts "Error Message: #{e.error}"
  puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
  $db.close if $db
end
