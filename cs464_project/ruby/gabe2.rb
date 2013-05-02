#!/usr/bin/ruby

# Coded by Gabriel Arrillaga

require 'mysql'

def createInteractions
  impressions = ['playing games','likes me','loves me','hates me','dislikes me',
  'need to take things slow','crazy','flirtatious','boring','long-term potential']
  mediums = ['e-mail','social network','texting','phone call','in person']
  locations = ['restaurant','bar','transit','coffee shop','apartment','campus']

  personIDs = $db.query("SELECT personID FROM Person")
  numPers = personIDs.num_rows()

  for i in 0..10000
    thisPerson = personIDs.field_seek((rand()*numPers).to_i)
    thisMedium = mediums.sample
    thisImpression = impressions.sample
    thisLocation = locations.sample
    thisTime = time_rand Time.local(2012,1,1), Time.local(2013,4,1)
    #results = db.query("INSERT INTO Interaction(impression,date_time,medium,location) VALUES ('#{thisImpression}','#{thisTime}','#{thisMedium}','#{thisLocation}')")
    results = $db.query("INSERT INTO Interaction(personID,impression,date_time,medium,location) VALUES ('#{thisPerson}','#{thisImpression}','#{thisTime}','#{thisMedium}','#{thisLocation}')")
  end
end

def time_rand from = 0.0, to = Time.now
  Time.at(from + rand * (to.to_f - from.to_f))
end


begin

  $db = Mysql.new("127.0.0.1", "root", "birdistheword", "dating_db")
  # $db.query("DELETE FROM Interactions;")
  createInteractions

rescue Mysql::Error => e
  puts "Error Code: #{e.errno}"
  puts "Error Message: #{e.error}"
  puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
  $db.close if $db
end



