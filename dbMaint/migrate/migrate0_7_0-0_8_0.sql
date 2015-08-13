# Batched hardware, second (final) stage.  Generalize
# relationship support so it handles batched and unbatched,
# more than one relationship associated with a step, etc.

# Tables to be added: 
# MultiRelationshipType
CREATE TABLE MultiRelationshipType 
( id int NOT NULL AUTO_INCREMENT, 
  name varchar(255) NOT NULL,
  hardwareTypeId int NOT NULL,
  minorTypeId int NOT NULL,
  description varchar(255) DEFAULT NULL,
  singleBatch tinyint NOT NULL default "1" COMMENT "By default batched relationship is satisfied with a single batch",
  nMinorItems int NOT NULL default "1" COMMENT "By default use just one subordinate item in a relationship but may be more",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk280 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType(id),
  CONSTRAINT fk281 FOREIGN KEY (minorTypeId) REFERENCES HardwareType(id),
  INDEX ix280 (hardwareTypeId),
  INDEX ix281 (minorTypeId),
  CONSTRAINT ix282 UNIQUE INDEX (name, hardwareTypeId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='describes relationship between two hardware types, one (which may be batched) subsidiary to the other';

# MultiRelationshipSlotType  (references a MultiRelationshipType)
# if relationship type has singleBatch=1 (true), just need one of these to
# represent all slots.  Otherwise slots may be distinguishable, so need
# nBatchedItems of them
CREATE TABLE MultiRelationshipSlotType
( id int NOT NULL AUTO_INCREMENT,
  multiRelationshipTypeId int NOT NULL,
  slotname varchar(255) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk286 FOREIGN KEY (multiRelationshipTypeId) REFERENCES MultiRelationshipType(id),
  INDEX ix286 (multiRelationshipTypeId),
  CONSTRAINT ix287 UNIQUE (multiRelationshipTypeId, slotname)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='names for slots for each subsidiary item';

# MultiRelationshipSlot (instance.  May represent one or many batched items
# or one "regular" item)
CREATE TABLE MultiRelationshipSlot
( id int NOT NULL AUTO_INCREMENT,
  multiRelationshipSlotTypeId int NOT NULL,
  minorId int NOT NULL COMMENT "batch from which 1 or nBatchedItems come or regular tracked hardware instance",
  hardwareId int NOT NULL COMMENT "parent component in assembly",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk300 FOREIGN KEY (multiRelationshipSlotTypeId) REFERENCES MultiRelationshipSlotType(id),
  CONSTRAINT fk301 FOREIGN KEY (hardwareId) REFERENCES Hardware(id),
  CONSTRAINT fk302 FOREIGN KEY (minorId) REFERENCES Hardware(id),
  INDEX ix300 (multiRelationshipSlotTypeId),
  INDEX ix301 (hardwareId),
  INDEX ix302 (minorId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='batched (or not) slot instance. May represent 1 or several items';

CREATE TABLE MultiRelationshipAction
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX ix305 (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='values assign, install, uninstall...';

CREATE TABLE MultiRelationshipHistory
( id int NOT NULL AUTO_INCREMENT,
  multiRelationshipSlotId int NOT NULL,
  multiRelationshipActionId int NOT NULL,
  activityId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk310 FOREIGN KEY (multiRelationshipSlotId) REFERENCES MultiRelationshipSlot(id),
  CONSTRAINT fk311 FOREIGN KEY (multiRelationshipActionId) REFERENCES MultiRelationshipAction(id),
  CONSTRAINT fk312 FOREIGN KEY (activityId) REFERENCES Activity(id),
  INDEX ix310 (multiRelationshipSlotId),
  INDEX ix311 (multiRelationshipActionId),
  INDEX ix312 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE ProcessRelationshipTag
( id int NOT NULL AUTO_INCREMENT,
  processId int NOT NULL,
  multiRelationshipTypeId int NOT NULL,
  multiRelationshipActionId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk320 FOREIGN KEY (processId) REFERENCES Process(id),
  CONSTRAINT fk321 FOREIGN KEY (multiRelationshipTypeId) REFERENCES MultiRelationshipType(id),
  CONSTRAINT fk322 FOREIGN KEY (multiRelationshipActionId) REFERENCES MultiRelationshipAction(id),
  INDEX ix320 (processId),
  INDEX ix321 (multiRelationshipTypeId),
  INDEX ix322 (multiRelationshipActionId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

# Modify tables - get rid of constraints on Process.hardwareRelationshipTypeId
#   Activity.hardwareRelationId
ALTER TABLE Process drop foreign key fk41;
ALTER TABLE Process drop index fk41;
ALTER TABLE Activity drop foreign key fk71;
ALTER TABLE Activity drop index fk71;
## maybe also 
##  alter table Process drop hardwareRelationshipTypeId;
##  alter table Activity drop hardwareRelationshipId;
  
# Inserts
insert into MultiRelationshipAction (name, createdBy, creationTS) values ('assign', 'jrb', UTC_TIMESTAMP());
insert into MultiRelationshipAction (name, createdBy, creationTS) values ('install', 'jrb', UTC_TIMESTAMP());
insert into MultiRelationshipAction (name, createdBy, creationTS) values ('uninstall', 'jrb', UTC_TIMESTAMP());

#   Insert new DbRelease row for 0.8.0
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 8, 0, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Complete support of batched hardware; generalize handling of hardware relationships');


