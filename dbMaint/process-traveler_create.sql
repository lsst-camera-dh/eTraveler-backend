source process-traveler_drop.sql
CREATE TABLE HardwareType 
( id int NOT NULL AUTO_INCREMENT, 
  name varchar(50) NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix1 UNIQUE (name) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
insert into HardwareType (name, createdBy, creationTS) values ('CCD', 'jrb', NOW());
insert into HardwareType (name, createdBy, creationTS) values ('Raft', 'jrb', NOW());
insert into HardwareType (name, createdBy, creationTS) values ('Lens', 'jrb', NOW());
insert into HardwareType (name, createdBy, creationTS) values ('Filter', 'jrb', NOW());
insert into HardwareType (name, createdBy, creationTS) values ('ASPIC chip', 'jrb', NOW());
insert into HardwareType (name, createdBy, creationTS) values ('CABAC Chip', 'jrb', NOW());

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
insert into HardwareIdentifierAuthority (authorityName, createdBy, creationTS) values ('BNL', 'jrb', NOW());
insert into HardwareIdentifierAuthority (authorityName, createdBy, creationTS) values ('SerialNumber', 'jrb', NOW());

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

CREATE TABLE HardwareRelationshipType 
( id int NOT NULL AUTO_INCREMENT, 
  relationshipName varchar(50) NOT NULL,
  hardwareTypeId int NOT NULL,
  componentTypeId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  constraint fk8 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType(id),
  constraint fk9 FOREIGN KEY (componentTypeId) REFERENCES HardwareType(id),
  INDEX fk8 (hardwareTypeId),
  INDEX fk9 (componentTypeId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='describes relationship between two hardware types, one subsidiary to the other';

insert into HardwareRelationshipType set relationshipName='Raft_CCD_1_1',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set relationshipName='Raft_CCD_1_2',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set relationshipName='Raft_CCD_1_3',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set relationshipName='Raft_CCD_2_1',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set relationshipName='Raft_CCD_2_2',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set relationshipName='Raft_CCD_2_3',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set relationshipName='Raft_CCD_3_1',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set relationshipName='Raft_CCD_3_2',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set relationshipName='Raft_CCD_3_3',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

CREATE TABLE HardwareRelationship 
( id int NOT NULL AUTO_INCREMENT, 
  hardwareId int NOT NULL, 
  componentId int NOT NULL, 
  begin timestamp NULL, 
  end timestamp NULL, 
  hardwareRelationshipTypeId int NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk10 FOREIGN KEY (hardwareId) REFERENCES Hardware (id) , 
  CONSTRAINT fk11 FOREIGN KEY (componentId) REFERENCES Hardware (id) , 
  CONSTRAINT fk12 FOREIGN KEY (hardwareRelationshipTypeId) REFERENCES HardwareRelationshipType (id), 
  INDEX fk10 (hardwareId), 
  INDEX fk11 (componentId), 
  INDEX fk12 (hardwareRelationshipTypeId) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Instance of HardwareRelationshipType between actual pieces of hardware';


CREATE TABLE Process 
( id int NOT NULL AUTO_INCREMENT, 
  processName varchar(50) NOT NULL, 
  hardwareTypeId int NOT NULL, 
  hardwareRelationshipTypeId int NULL, 
  processVersion int NOT NULL, 
  description blob, instructionsURL varchar(256), 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk40 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType (id), 
  CONSTRAINT fk41 FOREIGN KEY (hardwareRelationshipTypeId) REFERENCES HardwareRelationshipType (id), 
  INDEX fk40 (hardwareTypeId),
  INDEX fk41 (hardwareRelationshipTypeId),
  CONSTRAINT fk42 UNIQUE INDEX (processName, hardwareTypeId, processVersion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE ProcessEdge 
( id int NOT NULL AUTO_INCREMENT, parent int NOT NULL, 
  child int NOT NULL, step int NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk32 UNIQUE INDEX (parent, step),
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
  hardwareId int NOT NULL COMMENT "hardware in whose behalf activity occurred", 
  hardwareRelationshipId int NULL COMMENT "relationship pertinent to activity, if any", 
  processId int NOT NULL, 
  processEdgeid int NULL
   COMMENT "edge used to get to process; NULL for root",
  begin timestamp NULL, 
  end timestamp NULL, 
  inNCR ENUM ('TRUE', 'FALSE')  default 'FALSE',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk70 FOREIGN KEY (hardwareId) REFERENCES Hardware (id), 
  CONSTRAINT fk71 FOREIGN KEY (hardwareRelationshipId) REFERENCES HardwareRelationship (id), 
  CONSTRAINT fk72 FOREIGN KEY (processId) REFERENCES Process (id) , 
  CONSTRAINT fk73 FOREIGN KEY (processEdgeId) REFERENCES ProcessEdge (id), 
  INDEX fk70 (hardwareId),
  INDEX fk71 (hardwareRelationshipId),
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



