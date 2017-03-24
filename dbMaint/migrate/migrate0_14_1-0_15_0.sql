
-- New table code should be added to process-traveler_create
CREATE TABLE Labelable
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL COMMENT "Kind of thing to which labels are applied",
  tableName varchar(255) NOT NULL COMMENT "table where a row represents the thing to be labeled",
  hardwareGroupExpr varchar(255) NULL COMMENT "expression to find hardware group id(s) associated with an object in tableName",
  subsystemExpr varchar(255) NULL COMMENT "expression to find subsystem id associated with an object in tableName",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT uix399 UNIQUE INDEX(name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE LabelGroup
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  mutuallyExclusive tinyint NOT NULL default '0',
  defaultLabelId int NULL
  subsystemId int NULL,
  hardwareGroupId int NULL,
  labelableId int NOT NULL  COMMENT "if non-null group has must-be-present property",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk400 FOREIGN KEY (subsystemId) REFERENCES Subsystem(id),
  CONSTRAINT fk401 FOREIGN KEY (hardwareGroupId) REFERENCES HardwareGroup(id),
  CONSTRAINT fk402 FOREIGN KEY (labelableId) REFERENCES Labelable(id),
  CONSTRAINT uix403  UNIQUE INDEX(name, labelableId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Label
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  labelGroupId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk410 FOREIGN KEY (labelGroupId) REFERENCES LabelGroup(id),
  CONSTRAINT uix411 UNIQUE INDEX (labelGroupId, name),
  INDEX ix410 (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE LabelHistory
( id int NOT NULL AUTO_INCREMENT,
  objectId int NOT NULL,
  labelableId int NOT NULL COMMENT "Convenience. Can be looked up from labelId",
  labelId  int NOT NULL,
  reason text default "" COMMENT "e.g. initialized, used, discarded..",
  adding tinyint NOT NULL default '1',
  activityId int NULL COMMENT 'activity (if any) associated with change',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk420 FOREIGN KEY (labelId) REFERENCES Label(id),
  CONSTRAINT fk421 FOREIGN KEY (labelableId) REFERENCES Labelable(id),
  INDEX ix422 (objectId, labelableId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Add a field to TravelerType to indicate that a traveler may be
--  used as stand-alone NCR
alter table TravelerType add column standaloneNCR tinyint NOT NULL default '0' after state;

-- Make path fields in ExceptionType nullable
alter table ExceptionType modify column exitProcessPath varchar(2000)  NULL COMMENT 'period separated list of processEdge ids from traveler root to exit process' after conditionString;

alter table ExceptionType modify column returnProcessPath varchar(2000)  NULL COMMENT 'period separated list of processEdge ids from traveler root to return process' after exitProcessPath;

-- Code to set up labelable object types belongs in process-traveler_infra
-- First enumerate labelable objects
insert into Labelable (name, tableName, createdBy, creationTS) values ('run', 'RunNumber', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('hardware', 'Hardware', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('hardware_type', 'HardwareType', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('NCR', 'Exception', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('travelerType', 'TravelerType', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('location', 'Location', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('label', 'Label', 'jrb', UTC_TIMESTAMP());

-- Create stored procedures to get subsystem, hardware group(s) associated
-- with a label, one of each for each labelable type
source ../proc/NCR_subsystemProc.sql;
source ../proc/NCR_hardwareGroupsProc.sql;
source ../proc/hardwareType_subsystemProc.sql;
source ../proc/hardwareType_hardwareGroupsProc.sql;
source ../proc/hardware_subsystemProc.sql;
source ../proc/hardware_hardwareGroupsProc.sql;
source ../proc/label_subsystemProc.sql;
source ../proc/label_hardwareGroupsProc.sql;
source ../proc/run_subsystemProc.sql;
source ../proc/run_hardwareGroupsProc.sql;
source ../proc/travelerType_subsystemProc.sql;
source ../proc/travelerType_hardwareGroupsProc.sql;

-- and create the generic procedures which case on object type
source ../proc/generic_subsystemProc.sql;
source ../proc/generic_hardwareGroupsProc.sql;

-- Add Process.jobname
alter table Process add column jobname varchar(255) null after version;

-- update DbRelease
update DbRelease set status='OLD' where major='0' and minor='14' and patch='1';
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '0', 'CURRENT', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Generic label support');
