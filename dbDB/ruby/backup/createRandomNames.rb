#!/usr/bin/ruby
################################################################################
# Tool to create Random Names.
#
# Jayson Grace < jaysong@unm.edu >
# Version 1.0
# since 2013-03-24
#
################################################################################
require 'mysql'

# Global Variables
$emails = ['gmail.com','hotmail.com','yahoo.com','me.com','unm.edu','cs.unm.edu']
#email = first + last[0,1] + '@' + $emails[$emailRandNum]
#fnRandNum = (rand() * $firstNameArray.length).to_i
#lnRandNum = (rand() * $lastNameArray.length).to_i
#emailRandNum = (rand * emails.length).to_i
#   first = firstNameArray[fnRandNum].delete("\n")
#    last = lastNameArray[lnRandNum].delete("\n")
#    fullName = first + ' ' + last



def deleteEntireTable(table)
  puts "TACK #{table}"
  # delete everything
  $db.query("DELETE FROM #{table}")
  # Reset the auto incrementer
  $db.query("ALTER TABLE #{table} AUTO_INCREMENT = 0")
end

#def retrieveFromName
#  rs = db.query("SELECT * FROM Person")
#  n_rows = rs.num_rows
  
#  puts "There are {n_rows} rows in the result set"
  
#  n_rows.times do
#    puts rs.fetch_row.join("\s")
#  end
#end

# Generate random Females and put them into our database
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
  
  # lets generate some random names!
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
  
  # lets generate some random names!
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
  
  createRandomFemales
  createRandomMales
  deleteEntireTable('Person')
  
rescue Mysql::Error => e
  puts "Error Code: #{e.errno}"
  puts "Error Message: #{e.error}"
  puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
  $db.close if $db
end











