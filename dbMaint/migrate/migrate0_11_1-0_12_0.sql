-- Add fields to FilepathResultHarnessed to help common searches
alter table FilepathResultHarnessed add datatype varchar(255) COMMENT "datatype used to register in Data Catalog" after catalogKey;
alter table FilepathResultHarnessed add basename varchar(255) COMMENT "extracted from full filepath stored in value" after value;
alter table FilepathResultHarnessed add index ix177 (datatype);
alter table FilepathResultHarnessed add index ix178 (basename);

-- Create a table associating a root activity id with a run number
CREATE TABLE RunNumber
( id int NOT NULL AUTO_INCREMENT,
  runNumber varchar(15) COMMENT "Digits optionally followed by 1 alpha char",
  rootActivityId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  CONSTRAINT fk370 FOREIGN KEY(rootActivityId) REFERENCES Activity(id),
  PRIMARY KEY(id),
  INDEX ix371 (runNumber),
  UNIQUE INDEX ix372 (rootActivityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Associate run number with traveler execution';

INSERT into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '12', '0', 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Run numbers. Better searching of harnessed job file output');




