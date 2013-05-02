#!/usr/bin/ruby

require 'mysql'

# Global variables.
$emails = ['gmail.com','hotmail.com','yahoo.com','me.com','unm.edu','cs.unm.edu\
']
# Function to delete table, called before generating new fake data.
def deleteEntireTable(table)
  # delete everything
  $db.query("DELETE FROM #{table}")
  # Reset the auto incrementer
  $db.query("ALTER TABLE #{table} AUTO_INCREMENT = 0")
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
        second4 = rand(10000)
        i=(rand()*areaCodes.length).to_i
        phone = areaCodes[i].to_s << "-" << first3.to_s << "-" << second4.to_s
        return phone
end

def createRandomCompat
        return rand(11)
end

def chooseReligion
        religions = ['Christian', 'Jewish', 'Muslim', 'Scientologist', 'Atheist', 'Other', 'Agnostic', 'Catholic', 'Protestant', 'Pagan','Hindu',
'Buddhist','Sikh','Rastafarian']
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


# Generate random facts and put them into the database.
def createFactoids
        fn = File.open("./facts.txt");
        facts = []
  fn.each_line{|line| facts << line}
        fn.close
        i = 0
        j=0
        personIDs = $db.query("SELECT personID FROM Person")
        numRows = personIDs.num_rows()
        while i<10000
           thisPerson = personIDs.field_seek((rand()*numRows).to_i)
          $db.query("INSERT INTO Info(factoid,personID) VALUES('#{facts[i%facts.length]}','#{thisPerson}')")
                i+=1;
        end
end


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

# Generate 500 complete tuples for the Person entity.
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
    results = $db.query("INSERT INTO Person(name,gender,email,phone,contact_preference,religion,politics,dob,compatibility) VALUES ('#{fullName}','f','#{email}','#{phone}','#{contact_preference}','#{religion}','#{politics}','#{dob}','#{compatibility}')")
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

  # Generate 500 males for the Person entity.
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
    results = $db.query("INSERT INTO Person(name,gender,email,phone,contact_preference,religion,politics,dob,compatibility) VALUES ('#{fullName}','m','#{email}','#{phone}','#{contact_preference}','#{religion}','#{politics}','#{dob}','#{compatibility}')")
  end
end


begin
  # connect to the MYSQL server
  $db = Mysql.new("127.0.0.1", "root", "birdistheword", "dating_db")
  
  puts "Hello, this will populate the Person, Factoid, and Remember tables."
  
  # Clear the tables and reset the auto-inc ids.
  deleteEntireTable('Person')
  deleteEntireTable('Info')
  $db.query('ALTER TABLE Person AUTO_INCREMENT =1')
  $db.query('ALTER TABLE Info AUTO_INCREMENT=1')
  
        # Populate the tables.
  createRandomFemales
  createRandomMales
  createFactoids
  
rescue Mysql::Error => e
  puts "Error Code: #{e.errno}"
  puts "Error Message: #{e.error}"
  puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
  $db.close if $db
end








