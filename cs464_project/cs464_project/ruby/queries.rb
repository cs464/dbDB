#!/usr/bin/ruby
###############################################################################\
# Tool to create Tables.
#
# Gabe Arrillaga < gabea@unm.edu >
# Tim Dukes < tdukes@unm.edu >
# Jayson Grace < jaysong@unm.edu >
#
# Version 1.0
# since 2013-04-12
#
###############################################################################
require 'mysql' 

# 3 GENERAL QUERIES

def getReligionPolitics(thisReligion, thisPolitic)
  results = $db.query("
		SELECT name, compatibility 
		FROM Person 
		WHERE religion = '#{thisReligion}' and politics = '#{thisPolitic}'; 	
		")
  return results
end

def contactInfo(thisPerson)
  results = $db.query("
		SELECT name, (CASE WHEN preference IN ('text','phone') THEN phone ELSE e-mail)
		FROM Person
		WHERE personID = #{thisPerson};
		")
  return results
end

def oppositesAttract
  results = $db.query("
		SELECT personID 
		FROM Person 
		WHERE compatibility <= 1 AND personID NOT IN 
		    (SELECT Person.personID
                     FROM Person
                     INNER JOIN Interaction ON Person.personID = Interaction.personID
                     WHERE Interaction.impression = 'long-term potential'
                     GROUP BY Person.personID) AS long-term;
		")
  return results
end

# 2 JOIN QUERIES

def mostRecentInteractionQuery(thisPerson)
  results = $db.query("
	SELECT Person.name, Interaction.date_time, Interaction.medium, Communication.content
	FROM Person 
	INNER JOIN Interaction ON Person.personID = Interaction.personID
	INNER JOIN Communication ON Interaction.interactionID = Communication.interactionID
	WHERE Person.personID = #{thisPerson} AND Interaction.date_time = (SELECT MAX(date_time) FROM Interaction WHERE personID = #{thisPerson});
	")
  return results
end

def funniestNonRepublicans
  results = $db.query("
		SELECT name, phone
		FROM Person
		WHERE personID IN 
                    (SELECT thisPerson 
                     FROM (SELECT Person.personID AS thisPerson, MAX(Communication.content) 
                           FROM Person
                           INNER JOIN Interaction ON Person.personID = Interaction.personID
                           INNER JOIN Communication ON Interaction.interactionID = Communication.interactionID
                           WHERE Communication.content = 'joke' AND Person.politics <> 'Republican'
                           GROUP BY Person.personID) AS funnyPerson);
	")
  return results
end
=begin







=end

#TWO UPDATES###########################

#Everyone who was interested in Yoga is now interested in Hot Yoga.
def yogaChange
  results = $db.query("
  		UPDATE Interest
  		SET name='Hot Yoga'
  		WHERE name='Yoga';
  	")
end

#Everyone's compatibility is decremented by 1, unless it was 0.
def compatibilityChange
  results = $db.query("
  		UPDATE Person
  		SET compatibility=compatibility-1
  		WHERE compatibility>0;
  	")
end

#TWO DELETIONS########################

#Dump all Libertarians.
def dumpLibertarians
  results = $db.query("
  		DELETE
		FROM Person
		WHERE politics='Libertarian';
  	")
end

#Delete dates that are more than one year in the past.
def deletePastDates
  results = $db.query("
		DELETE 
		FROM Interaction
		WHERE (DATEDIFF(CURRENT_TIMESTAMP,date_time)>365);
  	")
end


#TWO INSERTIONS#########################
#If someone is interested in yoga, add the fact that they are flexible.
def flexible
  results = $db.query("
  		INSERT INTO Info(factoid,personID)
SELECT 'can touch their toes', Interest.personID
FROM Interest
WHERE Interest.name = 'Yoga' OR Interest.name='Hot Yoga';
  	")
end

#Keep track of who is interested in talking about taxes.
def lovesTaxes
  results = $db.query("
INSERT INTO Interest(name,details,personID)
SELECT 'taxes','they are against it', personID
FROM Person
WHERE politics = 'Libertarian' OR politics = 'Republican';
  	")
end

#ONE UNION###########################

#Who have you been on multiple dates with OR know multiple facts about.
#This query takes a long time, will indexes help?
def wellKnown
  results = $db.query("
 SELECT DISTINCT(name) AS wellknown
FROM Person 
WHERE personID IN 
  (SELECT personID 
  FROM
    (SELECT Interaction.personID,COUNT(*) AS intct 
    FROM Interaction 
    GROUP BY Interaction.personID)AS datecount 
  WHERE intct>1 
  UNION 
  SELECT personID 
  FROM
    (SELECT Info.personID,COUNT(*) AS infct 
    FROM Info 
    GROUP BY Info.personID)AS infocount 
  WHERE infct>1);
  	")
end

#ONE GROUP BY ##############################

#Determine which days have the most dates.
def mostDatesOnDay
  results = $db.query("
SELECT dates,WEEKDAY(day) 
FROM 
  (SELECT date_time AS day,COUNT(*) AS dates 
  FROM Interaction 
  GROUP BY WEEKDAY(date_time))AS datecount;
  	")
end


#ONE ORDER BY ################################

#List top ten people ordered by compatibility. Break ties with number of dates.
def topTenBreakTies
  results = $db.query("
SELECT name,compatibility,COUNT(*) as numDates 
FROM Person JOIN Interaction ON Person.personID = Interaction.personID 
GROUP BY Person.personID  
ORDER BY compatibility DESC ,numDates DESC LIMIT 0,10;
  	")
end

#ONE DISTINCT ###############################
#Determine distinct locations of dates in past month.

def dateLocations
  results = $db.query("
SELECT DISTINCT(location)
FROM Interaction
WHERE(DATEDIFF(CURRENT_TIMESTAMP,date_time)<31);
  	")
end

#ONE AGGREGATE ############################3
#Determine average compatibility for each political affiliation.
def findAvgCompatibility
  results = $db.query("
SELECT AVG(compatibility), politics
FROM Person
GROUP BY politics;
  	")
end

begin
  $db = Mysql.new("127.0.0.1", "root", "birdistheword", "dating_db")
  
#  results = getReligionPolitics("Jewish","Republican")
#  results = contactInfo(1)
 results = jokesAndPolitics()

results.each do |array|
    array.each do |value|
        puts value
    end
    puts
end 
  
rescue Mysql::Error => e
  puts "Error Code: #{e.errno}"
  puts "Error Message: #{e.error}"
  puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
  $db.close if $db
end
