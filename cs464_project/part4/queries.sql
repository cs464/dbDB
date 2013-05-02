
#TWO UPDATES###########################
#Everyone who was interested in Yoga is now interested in Hot Yoga.
UPDATE Interest
SET name="Hot Yoga"
WHERE name="Yoga";

#Everyone's compatibility is decremented by 1, unless it was 0.
UPDATE Person
SET compatibility=compatibility-1
WHERE compatibility>0;

#TWO DELETIONS########################
#Dump all Libertarians.
DELETE
FROM Person
WHERE politics="Libertarian";

#Delete dates that are more than one year in the past.
DELETE 
FROM Interaction
WHERE (DATEDIFF(CURRENT_TIMESTAMP,date_time)>365);

#TWO INSERTIONS#########################
#If someone is interested in yoga, add the fact that they are flexible.
INSERT INTO Info(factoid,personID)
SELECT "can touch their toes", Interest.personID
FROM Interest
WHERE Interest.name = "Yoga" OR Interest.name="Hot Yoga";

#Keep track of who is interested in talking about taxes.
INSERT INTO Interest(name,details,personID)
SELECT "taxes","they are against it", personID
FROM Person
WHERE politics = "Libertarian" OR politics = "Republican";

#ONE UNION###########################
#Who have you been on multiple dates with OR know multiple facts about.
#This query takes a long time, will indexes help?
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
	WHERE infct>1)
;

SELECT DISTINCT(name) AS wellknown
FROM people
WHERE personID IN 
	(SELECT personID 
	FROM
		(SELECT interactions.personID,COUNT(*) AS intct 
		FROM interactions
		GROUP BY interactions.personID)AS datecount 
	WHERE intct>1 
	UNION 
	SELECT personID 
	FROM
		(SELECT infos.personID,COUNT(*) AS infct 
		FROM infos
		GROUP BY infos.personID)AS infocount 
	WHERE infct>1)
;


#ONE GROUP BY ##############################
#Determine which days have the most dates.
SELECT dates,WEEKDAY(day) 
FROM 
	(SELECT date_time AS day,COUNT(*) AS dates 
	FROM Interaction 
	GROUP BY WEEKDAY(date_time))AS datecount;

SELECT dates,WEEKDAY(day) 
FROM 
	(SELECT date_time AS day,COUNT(*) AS dates 
	FROM interactions 
	GROUP BY WEEKDAY(date_time))AS datecount;



#ONE ORDER BY ################################
#List top ten people ordered by compatibility. Break ties with number of dates.
SELECT name,compatibility,COUNT(*) as numDates 
FROM Person JOIN Interaction ON Person.personID = Interaction.personID 
GROUP BY Person.personID  
ORDER BY compatibility DESC ,numDates DESC LIMIT 0,10;

SELECT name,compatibility,COUNT(*) as numDates 
FROM people JOIN interactions ON people.personID = interactions.personID 
GROUP BY people.personID  
ORDER BY compatibility DESC ,numDates DESC LIMIT 0,10;


#ONE DISTINCT ###############################
#Determine distinct locations of dates in past month.
SELECT DISTINCT(location)
FROM Interaction
WHERE(DATEDIFF(CURRENT_TIMESTAMP,date_time)<31);O

# Show people being dated by more than one user
SELECT name, COUNT( * ) 
FROM people
GROUP BY name
ORDER BY COUNT( * ) DESC
 

#ONE AGGREGATE ############################3
#Determine average compatibility for each political affiliation.
SELECT AVG(compatibility), politics
FROM Person
GROUP BY politics;


SELECT name, compatibility 
		FROM Person 
		WHERE religion = 'Atheist' AND politics = 'Other';


SELECT name, contact_preference
		FROM Person
		WHERE personID = 2;


	SELECT personID 
		FROM Person 
		WHERE compatibility <= 5 AND personID NOT IN 
		    (SELECT Person.personID
			FROM Person
			INNER JOIN Interaction ON Person.personID = Interaction.personID
			WHERE Interaction.impression = 'long-term potential'
			GROUP BY Person.personID);



SELECT Person.name, Interaction.date_time, Interaction.medium, Communication.content
FROM Person
INNER JOIN Interaction ON Person.personID = Interaction.personID
INNER JOIN Communication ON Interaction.interactionID = Communication.interactionID
WHERE Person.personID =4
AND Interaction.date_time = ( 
SELECT MAX( date_time ) 
FROM Interaction
WHERE personID =4 )


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
 