source process-traveler_drop.sql
CREATE TABLE HardwareType 
( id int NOT NULL AUTO_INCREMENT, 
  name varchar(50) NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix1 UNIQUE (name) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
insert into HardwareType (name) values ('CCD');
insert into HardwareType (name) values ('Raft');
insert into HardwareType (name) values ('Lens');
insert into HardwareType (name) values ('Filter');
insert into HardwareType (name) values ('ASPIC chip');
insert into HardwareType (name) values ('CABAC Chip');

CREATE TABLE Hardware 
( id int NOT NULL AUTO_INCREMENT, 
  TypeId int NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk1 FOREIGN KEY (TypeId) REFERENCES HardwareType (id), 
  INDEX fk1 (TypeId) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE HardwareIdentifierAuthority 
( id int NOT NULL AUTO_INCREMENT, 
  authorityName varchar(100) NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT ix1 UNIQUE (authorityName) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
insert into HardwareIdentifierAuthority (authorityName) values ('BNL');
insert into HardwareIdentifierAuthority (authorityName) values ('SerialNumber');

CREATE TABLE HardwareIdentifier 
( id int NOT NULL AUTO_INCREMENT, 
  authorityId int NOT NULL COMMENT "site or other authority for assigning this identifier", 
  hardwareId int NOT NULL    COMMENT "reference to hardware instance getting identifier", 
  identifier varchar(100) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk3 FOREIGN KEY (authorityId) REFERENCES HardwareIdentifierAuthority (id) , 
  CONSTRAINT fk4 FOREIGN KEY (hardwareId) REFERENCES Hardware (id), 
  INDEX fk3 (authorityId), 
  INDEX fk4 (hardwareId) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE RelationshipType 
( id int NOT NULL AUTO_INCREMENT, 
  relationshipName varchar(50) NOT NULL,
  hardwareTypeId1 int NOT NULL,
  hardwareTypeId2 int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  constraint fk8 FOREIGN KEY (hardwareTypeId1) REFERENCES HardwareType(id),
  constraint fk9 FOREIGN KEY (hardwareTypeId2) REFERENCES HardwareType(id),
  INDEX fk8 (hardwareTypeId1),
  INDEX fk9 (hardwareTypeId2)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='describes relationship between two hardware types';

CREATE TABLE HardwareRelationship 
( id int NOT NULL AUTO_INCREMENT, 
  hardwareId1 int NOT NULL, 
  hardwareId2 int NOT NULL, 
  begin timestamp NULL, 
  end timestamp NULL, 
  relationshipTypeId int NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk10 FOREIGN KEY (hardwareId1) REFERENCES Hardware (id) , 
  CONSTRAINT fk11 FOREIGN KEY (hardwareId2) REFERENCES Hardware (id) , 
  CONSTRAINT fk12 FOREIGN KEY (relationshipTypeId) REFERENCES RelationshipType (id), 
  INDEX fk10 (hardwareId1), 
  INDEX fk11 (hardwareId2), 
  INDEX fk12 (relationshipTypeId) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Instance of RelationshipType between actual pieces of hardware';

CREATE TABLE ProcessVersion
( id int NOT NULL AUTO_INCREMENT, 
  versionString varchar(80) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT ix1 UNIQUE (versionString) 
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Process 
( id int NOT NULL AUTO_INCREMENT, 
  processName varchar(50) NOT NULL, 
  hardwareTypeId1 int NULL, 
  hardwareTypeId2 int NULL, 
  processVersionId int NOT NULL, 
  description blob, instructionsURL varchar(256), 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk40 FOREIGN KEY (hardwareTypeId1) REFERENCES HardwareType (id), 
  CONSTRAINT fk41 FOREIGN KEY (hardwareTypeId2) REFERENCES HardwareType (id), 
  CONSTRAINT fk42 FOREIGN KEY (processVersionId) REFERENCES ProcessVersion (id),
  INDEX fk40 (hardwareTypeId1),
  INDEX fk41 (hardwareTypeId2),
  INDEX fk42 (processVersionId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE ProcessEdge 
( id int NOT NULL AUTO_INCREMENT, parent int NOT NULL, 
  child int NOT NULL, step int NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk31 FOREIGN KEY (child) REFERENCES Process (id) , 
  CONSTRAINT fk30 FOREIGN KEY (parent) REFERENCES Process (id), 
  INDEX fk30 (parent), INDEX fk31 (child) 
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE NCRcondition
( id int NOT NULL AUTO_INCREMENT, 
  conditionString varchar(80) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT ix1 UNIQUE (conditionString) 
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Exception
( id int NOT NULL AUTO_INCREMENT, 
  exitProcessId int NOT NULL, 
  returnProcessId int NOT NULL,
  NCRProcessId int NOT NULL,  
  conditionId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk80 FOREIGN KEY (exitProcessId) REFERENCES Process (id),  
  CONSTRAINT fk81 FOREIGN KEY (returnProcessId) REFERENCES Process (id),  
  CONSTRAINT fk82 FOREIGN KEY (NCRProcessId) REFERENCES Process (id),
  CONSTRAINT fk83 FOREIGN KEY (conditionId) REFERENCES NCRcondition (id),
  INDEX fk80 (exitProcessId), INDEX fk81 (returnProcessId),
  INDEX fk82 (NCRProcessId) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Activity 
( id int NOT NULL AUTO_INCREMENT, 
  hardwareId1 int NULL COMMENT "hardware acted upon, if any", 
  hardwareId2 int NULL COMMENT "auxilliary hardware acted upon, if any", 
  processId int NOT NULL, 
  processEdgeid int NULL
   COMMENT "edge used to get to process; NULL for root",
  begin timestamp NULL, 
  end timestamp NULL, 
  inNCR ENUM ('TRUE', 'FALSE')  default 'FALSE',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk70 FOREIGN KEY (hardwareId1) REFERENCES Hardware (id), 
  CONSTRAINT fk71 FOREIGN KEY (hardwareId2) REFERENCES Hardware (id), 
  CONSTRAINT fk72 FOREIGN KEY (processId) REFERENCES Process (id) , 
  CONSTRAINT fk73 FOREIGN KEY (processEdgeId) REFERENCES ProcessEdge (id), 
  INDEX fk70 (hardwareId1),
  INDEX fk71 (hardwareId2),
  INDEX fk72 (processId), 
  INDEX fk73 (processEdgeId) 
)   ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Result 
( id int NOT NULL AUTO_INCREMENT, 
  activityId int NOT NULL, 
  status int NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk90 FOREIGN KEY (activityId) REFERENCES Activity (id), 
  INDEX fk90 (activityId) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



