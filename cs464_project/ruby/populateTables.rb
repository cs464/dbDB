#!/usr/bin/ruby
###############################################################################\
# Tool to create Tables.
#
# Jayson Grace < jaysong@unm.edu >
# Tim Dukes < tdukes@unm.edu >
# Gabe Arrillaga < gabea@unm.edu >
#
# Version 2.0
# since 2013-03-27
#
###############################################################################
require 'mysql'
require 'digest/sha1'
require 'securerandom'

# Global Variables
$emails = ['gmail.com','hotmail.com','yahoo.com','me.com','unm.edu','cs.unm.edu']

# Helper method for alphabet
def getAlphabet
  alphabet = "A".."Z"
  $alphabet_array = alphabet.to_a
end

# Debug method to hose a table and reset the auto_incremented ID
def deleteEntireTable(table)
  # delete everything
  $db.query("DELETE FROM #{table}")
  # Reset the auto incrementer
  $db.query("ALTER TABLE #{table} AUTO_INCREMENT = 1")
end

# Username, password hash
def createUser
  fn = File.open("./users.txt")
  usersArray = []
  fn.each_line {|line| usersArray << line}
  fn.close
  # number to append after username
  number = 1
  # Generate 1000 users
  for i in 0..10000
    user = usersArray.sample.delete("\n")
    userNumber = number.to_s
    username = user + userNumber
    number += 1
    # Generate random hex string for password
    password = SecureRandom.hex(13)
    # Remove spaces in the username that sometimes appear
    username.gsub!(/\s+/, '')
    # encrypt the passsword before it hits the database
    encrypted_password = Digest::SHA1.hexdigest(password)
    results = $db.query("INSERT INTO users(username,password_hash) VALUES ('#{username.downcase}','#{encrypted_password}')")
  end
end

# Name, Details -- information gathered from http://www.buzzle.com/articles/list-of-hobbies-interests.html
def createInterest
  fn = File.open("./activities.txt")
  interestsArray = []
  fn.each_line {|line| interestsArray << line}
  fn.close
  personIDs = $db.query("SELECT personID FROM people")
  personArray = Array.new
  personIDs.each do |row|
    personArray.push(row)
  end
  puts personArray
  
  for i in 0..10000
    thisPerson = personArray.sample[0]
    interest = interestsArray.sample
    if (/(.*);\s*(.*)/).match(interest)
      interest_name = $1
      interest_details = $2
      pattern = /(\'|\"|\.|\*|\/|\-|\\)/
      interest_details.gsub(pattern){|match|"\\"  + match}
      results = $db.query("INSERT INTO interests(name,details,personID) VALUES ('#{interest_name}','#{interest_details}','#{thisPerson}')")
    end
  end
end

# Coded by Gabriel Arrillaga
def createCommunications
  themes = ['story','joke','tease','personal','question','plans','sexual','comment']
  interactionIDs = $db.query("SELECT interactionID FROM interactions")
  interactionArray = Array.new
  interactionIDs.each do |row|
    interactionArray.push(row)
  end
  
  for i in 0..10000
    thisInteraction = interactionArray.sample[0]
    thisTheme = themes.sample
    thisContent = "totally unique and fascinating message " + i.to_s()
    results = $db.query("INSERT INTO communications(interactionID,content,theme)VALUES ('#{thisInteraction}','#{thisTheme}','#{thisContent}')")
  end
end

# Coded by Gabriel Arrillaga
def createInteractions
  impressions = ['playing games','likes me','loves me','hates me','dislikes me','need to take things slow','crazy','flirtatious','boring','long-term potential']
  mediums = ['e-mail','social network','texting','phone call','in person']
  locations = ['restaurant','bar','transit','coffee shop','apartment','campus']
  
  personIDs = $db.query("SELECT personID FROM people")
  personArray = Array.new
  personIDs.each do |row|
    personArray.push(row)
  end
  
  for i in 0..10000
    thisPerson = personArray.sample[0]
    thisMedium = mediums.sample
    thisImpression = impressions.sample
    thisLocation = locations.sample
    thisTime = time_rand Time.local(2012,1,1), Time.local(2013,4,1)
    results = $db.query("INSERT INTO interactions(personID,impression,date_time,medium,location) VALUES ('#{thisPerson}','#{thisImpression}','#{thisTime}','#{thisMedium}','#{thisLocation}')")
  end
end

# Written by Gabriel Arrillaga
def time_rand from = 0.0, to = Time.now
  Time.at(from + rand * (to.to_f - from.to_f))
end

def createRandomFemales
  fn = File.open("./femaleFirst.txt")
  firstNameArray = []
  fn.each_line {|line| firstNameArray << line}
  fn.close
  
  ln = File.open("./lastName.txt")
  lastNameArray = []
  ln.each_line {|line| lastNameArray << line}
  ln.close
  
  # Generate 5000 complete tuples for the Person entity.
  for i in 0..4999
    fnRandNum = (rand() * firstNameArray.length).to_i
    lnRandNum = (rand() * lastNameArray.length).to_i
    emailRandNum = (rand() * $emails.length).to_i
    first = firstNameArray[fnRandNum].delete("\n")
    last = lastNameArray[lnRandNum].delete("\n")
    fullName = first + ' ' + last
    email = first + last[0,1] + '@' + $emails[emailRandNum]
    phone = createRandomPhone
    contact_preference = chooseContactPref
    religion = chooseReligion
    politics = choosePolitics
    dob = createRandomDOB
    compatibility = createRandomCompat
    results = $db.query("INSERT INTO people(name,gender,email,phone,contact_preference,religion,politics,dob,compatibility) VALUES ('#{fullName}','f','#{email}','#{phone}','#{contact_preference}','#{religion}','#{politics}','#{dob}','#{compatibility}')")
  end
end

# Generate random facts and put them into the database.
def createFactoids
  fn = File.open("./facts.txt");
  facts = []
  fn.each_line{|line| facts << line}
  fn.close
  i = 0
  j = 0
  personIDs = $db.query("SELECT personID FROM people")
  personArray = Array.new
  personIDs.each do |row|
    personArray.push(row)
  end

  while i<10000
    thisPerson = personArray.sample[0]
    fact=facts[i%facts.length]
    $db.query("INSERT INTO infos(factoid,personID) VALUES('#{fact}','#{thisPerson}')")
    i += 1
  end
end

# Generate random male names for Person Table.
def createRandomMales
  fn = File.open("./maleFirst.txt")
  firstNameArray = []
  fn.each_line {|line| firstNameArray << line}
  fn.close
  
  ln = File.open("./lastName.txt")
  lastNameArray = []
  ln.each_line {|line| lastNameArray << line}
  ln.close
  
  # Generate 5000 males for the Person entity.
  for i in 0..4999
    fnRandNum = (rand() * firstNameArray.length).to_i
    lnRandNum = (rand() * lastNameArray.length).to_i
    emailRandNum = (rand * $emails.length).to_i
    first = firstNameArray[fnRandNum].delete("\n")
    last = lastNameArray[lnRandNum].delete("\n")
    fullName = first + ' ' + last
    email = first + last[0,1] + '@' + $emails[emailRandNum]
    phone = createRandomPhone
    contact_preference = chooseContactPref
    religion = chooseReligion
    politics = choosePolitics
    dob = createRandomDOB
    compatibility = createRandomCompat
    results = $db.query("INSERT INTO people(name,gender,email,phone,contact_preference,religion,politics,dob,compatibility) VALUES ('#{fullName}','m','#{email}','#{phone}','#{contact_preference}','#{religion}','#{politics}','#{dob}','#{compatibility}')")
  end
end

# Various functions to create random data for Person entity.
def createRandomDOB
  next_dob=""
  next_dob << (rand(50)+1940).to_s << "-" << (rand(12)+1).to_s << "-" << (rand(28)+1).to_s
  return next_dob
end

def createRandomPhone
  areaCodes=['505','213','212','949','909','727','813','805']
  first3 = rand(800)+200
  second4 = rand(9000) + 1000
  i=(rand()*areaCodes.length).to_i
  phone = areaCodes[i].to_s << "-" << first3.to_s << "-" << second4.to_s
  return phone
end

def createRandomCompat
  return rand(11)
end

def chooseReligion
  religions = ['Christian', 'Jewish', 'Muslim', 'Scientologist', 'Atheist', 'Other', 'Agnostic', 'Catholic', 'Protestant', 'Pagan','Hindu', 'Buddhist','Sikh','Rastafarian']
  i = (rand()*religions.length).to_i
  return religions[i]
end

def choosePolitics
  politics = ['Democrat', 'Republican', 'Libertarian', 'Apathetic', 'Independent','Green','Other']
  i = (rand()*politics.length).to_i
  return politics[i]
end

def chooseContactPref
  contactPref = ['text', 'phone','email']
  i = (rand()*contactPref.length).to_i
  return contactPref[i]
end

#method to create Pursuing relationship, which links Person and User entities.
def createPursuing
  personIDs = $db.query("SELECT personID FROM people")
  personArray = Array.new
  personIDs.each do |row|
    personArray.push(row)
  end

  usernames = $db.query("SELECT username FROM users")
  userArray = Array.new
  usernames.each do |row|
    userArray.push(row)
  end

  for i in 0..10000
    thisUser = userArray.sample[0]
    thisPerson = personArray.sample[0]
    $db.query("INSERT INTO pursuings(username,personID) VALUES('#{thisUser}','#{thisPerson}')")
  end
end

begin
  # connect to the MYSQL server
  $db = Mysql.new("127.0.0.1", "root", "birdistheword", "dating_db")
  
  puts "Hello, this is program will generate all of your tables with data."
  
  # Debug statements to delete older data if it existed and reset all the auto incrementers
  deleteEntireTable('communications')
  deleteEntireTable('infos')
  deleteEntireTable('interactions')
  deleteEntireTable('interests')
  deleteEntireTable('people')
  deleteEntireTable('pursuings')
  deleteEntireTable('users')
  deleteEntireTable('pursuings')
  

# Method calls to populate Database      
getAlphabet
createUser
createRandomFemales
createRandomMales
createPursuing
 createInteractions
createFactoids
createCommunications
createInterest

# Mysql debug information  
rescue Mysql::Error => e
  puts "Error Code: #{e.errno}"
  puts "Error Message: #{e.error}"
  puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
  $db.close if $db
end
