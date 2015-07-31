DROP TABLE Exception;
DROP TABLE NCRcondition;
CREATE TABLE ExceptionType
( id int NOT NULL AUTO_INCREMENT, 
  conditionString varchar(80) NOT NULL,  
  exitProcessPath varchar(2000)  NOT NULL COMMENT 'comma separated list of processEdge ids from traveler root to exit process', 
  returnProcessPath varchar(2000) NOT NULL COMMENT 'comma separated list of processEdge ids from traveler root to return process', 
  exitProcessId int NOT NULL,
  rootProcessId int NOT NULL COMMENT 'id of root process for traveler exception is assoc. with',
  NCRProcessId int NOT NULL,  
  status ENUM('ENABLED', 'DISABLED') default 'ENABLED',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk80 FOREIGN KEY (exitProcessId) REFERENCES Process (id),
  CONSTRAINT fk81 FOREIGN KEY (rootProcessId) REFERENCES Process (id),
  CONSTRAINT fk82 FOREIGN KEY (NCRProcessId) REFERENCES Process (id),
  INDEX fk80 (exitProcessId),
  INDEX fk81 (rootProcessId),
  INDEX fk82 (NCRProcessId) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE Exception
( id int NOT NULL AUTO_INCREMENT,
  exceptionTypeId int NOT NULL COMMENT "ref. to exception definition",
  exitActivityId int NOT NULL COMMENT "normal activity in which exception occurs",
  NCRActivityId int NOT NULL COMMENT "first activity in NCR procedure",
  returnActivityId int NULL COMMENT "first normal activity after NCR",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk220 FOREIGN KEY(exceptionTypeId) REFERENCES ExceptionType(id),
  CONSTRAINT fk221 FOREIGN KEY(exitActivityId) REFERENCES Activity(id),
  CONSTRAINT fk222 FOREIGN KEY(NCRActivityId) REFERENCES Activity(id),
  CONSTRAINT fk223 FOREIGN KEY(returnActivityId) REFERENCES Activity(id),
  INDEX fk220 (exceptionTypeId),
  INDEX fk221 (exitActivityId),
  INDEX fk222 (NCRActivityId),
  INDEX fk223 (returnActivityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='describes exception instance';
ALTER TABLE TravelerType ADD owner varchar(50) COMMENT 'responsible party' after state;
ALTER TABLE TravelerType ADD reason varchar(255) COMMENT 'purpose of this traveler or traveler version' after owner;
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 4, 0, 'TEST', 'jrb', NOW(), NOW(), 'Merge Exception and NCRcondition; rename to ExceptionType. Add new table Exception for exception instances. Beef up TravelerType');
DROP TABLE HardwareLocationHistory;
ALTER TABLE HardwareStatusHistory FORCE;
CREATE TABLE HardwareLocationHistory
(id  int NOT NULL AUTO_INCREMENT,
  locationId int NOT NULL COMMENT "fk for the new location",
  hardwareId int NOT NULL COMMENT "component whose location is being updated",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk210 FOREIGN KEY(locationId) REFERENCES Location(id),
  CONSTRAINT fk211 FOREIGN KEY(hardwareId) REFERENCES Hardware(id),
  INDEX fk210 (locationId),
  INDEX fk211 (hardwareId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Keep track of all hardware location updates';
ALTER TABLE IntResultHarnessed modify schemaInstance int DEFAULT "0" COMMENT "Same schema may be used more than once in result summary";
ALTER TABLE FloatResultHarnessed modify schemaInstance int DEFAULT "0" COMMENT "Same schema may be used more than once in result summary";
ALTER TABLE FilepathResultHarnessed modify schemaInstance int DEFAULT "0" COMMENT "Same schema may be used more than once in result summary";
ALTER TABLE StringResultHarnessed modify schemaInstance int DEFAULT "0" COMMENT "Same schema may be used more than once in result summary";
