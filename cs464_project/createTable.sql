CREATE TABLE users (
username varchar(128) NOT NULL,
password_hash varchar(256) NOT NULL,
PRIMARY KEY(username));

CREATE TABLE pursuings (
username varchar(128) NOT NULL REFERENCES users(username),
personID int NOT NULL  REFERENCES  people(personID)
);

CREATE TABLE people(
personID int(15) NOT NULL AUTO_INCREMENT,
name varchar(128) NOT NULL,
gender ENUM('m','f') NOT NULL,
email varchar(128),
phone varchar(128),
contact_preference ENUM('text', 'phone','email'),
religion ENUM('Christian', 'Jewish', 'Muslim', 'Scientologist', 'Atheist', 'Other', 'Agnostic', 'Catholic', 'Protestant', 'Pagan','Hindu',
'Buddhist','Sikh','Rastafarian'),
politics ENUM('Democrat', 'Republican', 'Libertarian', 'Apathetic', 'Independent','Green','Other'),
dob DATE,
compatibility int,
PRIMARY KEY(personID)
);


CREATE TABLE infos(
factID int(15) NOT NULL AUTO_INCREMENT,
factoid varchar(256),
personID int(15) REFERENCES people(personID),
PRIMARY KEY(factID)
);

CREATE TABLE interactions(
interactionID int(15) NOT NULL AUTO_INCREMENT,
impression varchar(128),
date_time DATETIME NOT NULL,
medium varchar(128),
location varchar(128),
personID int(15) REFERENCES people(personID),
PRIMARY KEY(interactionID)
);


CREATE TABLE communications(
communicationID int(15) NOT NULL AUTO_INCREMENT,
content varchar(128),
theme varchar(64),
interactionID int(15) REFERENCES interactions(interactionID),
PRIMARY KEY(communicationID)
);


CREATE TABLE interests(
interestID int(15) NOT NULL AUTO_INCREMENT,
name varchar(128) NOT NULL,
details varchar(256) NOT NULL,
personID int(15) REFERENCES people(personID),
PRIMARY KEY(interestID)
);