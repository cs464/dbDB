#!/usr/bin/ruby
################################################################################
# Tool to create Random Names.
#
# Jayson Grace < jaysong@unm.edu >
# Version 1.2
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
    results = $db.query("INSERT INTO User(username,password_hash) VALUES ('#{username.downcase}','#{encrypted_password}')")
  end
end

# Name, Details -- information gathered from http://www.buzzle.com/articles/list-of-hobbies-interests.html
def createInterest
  fn = File.open("./activities.txt")
  interestsArray = []
  fn.each_line {|line| interestsArray << line}
  fn.close
  personIDs = $db.query("SELECT personID FROM Person")
  numInt = personIDs.num_rows()
  
  for i in 0..10000
    thisPerson = personIDs.field_seek((rand()*numInt).to_i)
    interest = interestsArray.sample
    if (/(.*);\s*(.*)/).match(interest)
      interest_name = $1
      interest_details = $2
      pattern = /(\'|\"|\.|\*|\/|\-|\\)/
      interest_details.gsub(pattern){|match|"\\"  + match}
      results = $db.query("INSERT INTO Interest(name,details,personID) VALUES ('#{interest_name}','#{interest_details}','#{thisPerson}')")
    end
  end
end

# Generate random females and put them into our database
def createRandomFemales
  fn = File.open("./femaleFirst.txt")
  firstNameArray = []
  fn.each_line {|line| firstNameArray << line}
  fn.close
  
  ln = File.open("./lastName.txt")
  lastNameArray = []
  ln.each_line {|line| lastNameArray << line}
  ln.close
  
  # debug get size of firstNameArray
  #puts firstNameArray.length
  
  # Generate random names
  for i in 0..10
    fnRandNum = (rand() * firstNameArray.length).to_i
    lnRandNum = (rand() * lastNameArray.length).to_i
    emailRandNum = (rand() * $emails.length).to_i
    first = firstNameArray[fnRandNum].delete("\n")
    last = lastNameArray[lnRandNum].delete("\n")
    fullName = first + ' ' + last
    email = first + last[0,1] + '@' + $emails[emailRandNum]
    results = $db.query("INSERT INTO Person(name,gender,email) VALUES ('#{fullName}','m','#{email}')")
  end
end

def createRandomMales
  fn = File.open("./maleFirst.txt")
  firstNameArray = []
  fn.each_line {|line| firstNameArray << line}
  fn.close
  
  ln = File.open("./lastName.txt")
  lastNameArray = []
  ln.each_line {|line| lastNameArray << line}
  ln.close
  
  # debug get size of firstNameArray
  #puts firstNameArray.length
  
  # lets generate some random names and shit!
  for i in 0..10
    fnRandNum = (rand() * firstNameArray.length).to_i
    lnRandNum = (rand() * lastNameArray.length).to_i
    emailRandNum = (rand * $emails.length).to_i
    first = firstNameArray[fnRandNum].delete("\n")
    last = lastNameArray[lnRandNum].delete("\n")
    fullName = first + ' ' + last
    email = first + last[0,1] + '@' + $emails[emailRandNum]
    results = $db.query("INSERT INTO Person(name,gender,email) VALUES ('#{fullName}','m','#{email}')")
  end
end

begin
  # connect to the MYSQL server
  $db = Mysql.new("127.0.0.1", "root", "birdistheword", "dating_db")
  
  # this will eventually be the entire interface to populate the Person DB.
  puts "Hello, this will generate random male & females names and put them into the Person table."
  
  getAlphabet 
  #  createRandomFemales
  #  createRandomMales
  
#  createUser
  createInterest
  
  # debug method used to complete hose the DB
  #  deleteEntireTable('User')
   # deleteEntireTable('Interest')
  
rescue Mysql::Error => e
  puts "Error Code: #{e.errno}"
  puts "Error Message: #{e.error}"
  puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
  $db.close if $db
end
