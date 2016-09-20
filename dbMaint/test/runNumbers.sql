-- Create a table associating a root activity id with a run number
CREATE TABLE RunNumber
( id int NOT NULL AUTO_INCREMENT,
  runNumber varchar(15) COMMENT "Digits optionally followed by 1 alpha char",
  rootActivityId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  CONSTRAINT fk370 FOREIGN KEY(rootActivityId) REFERENCES Activity(id),
  PRIMARY KEY(id),
  INDEX ix371 (runNumber)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Associate run number with traveler execution';

