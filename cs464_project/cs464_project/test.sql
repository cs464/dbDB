SELECT personID			
	FROM Person		
		WHERE compatibility <= 5 AND personID NOT IN 
		    (SELECT Person.personID
			FROM Person
			INNER JOIN Interaction ON Person.personID = Interaction.personID
			WHERE Interaction.impression = 'long-term potential'
			GROUP BY Person.personID);
		")